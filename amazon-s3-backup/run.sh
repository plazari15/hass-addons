#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Amazon S3 Backup
# ==============================================================================
#bashio::log.level "debug"

bashio::log.info "Starting Amazon S3 Backup..."

bucket_name="$(bashio::config 'bucket_name')"
storage_class="$(bashio::config 'storage_class' 'STANDARD')"
bucket_region="$(bashio::config 'bucket_region' 'eu-central-1')"
delete_local_backups="$(bashio::config 'delete_local_backups' 'true')"
local_backups_to_keep="$(bashio::config 'local_backups_to_keep' '3')"
sync_local_with_bucket="$(bashio::config 'sync_local_with_bucket' 'false')"
monitor_path="/backup"
jq_filter=".backups|=sort_by(.date)|.backups|reverse|.[$local_backups_to_keep:]|.[].slug"

export AWS_ACCESS_KEY_ID="$(bashio::config 'aws_access_key')"
export AWS_SECRET_ACCESS_KEY="$(bashio::config 'aws_secret_access_key')"
export AWS_REGION="$bucket_region"

bashio::log.info "Using AWS CLI version: '$(aws --version)'"

if bashio::var.true "${sync_local_with_bucket}"; then
    # If true for sync_local_with_bucket run this command
    bashio::log.info "Will sync deleting old backups in S3. This should be used with moderation."
    bashio::log.info "Command: 'aws s3 sync $monitor_path s3://$bucket_name/ --no-progress --region $bucket_region --storage-class $storage_class' --delete"
    aws s3 sync $monitor_path s3://"$bucket_name"/ --no-progress --region "$bucket_region" --storage-class "$storage_class" --delete
else
    bashio::log.info "Command: 'aws s3 sync $monitor_path s3://$bucket_name/ --no-progress --region $bucket_region --storage-class $storage_class'"
    aws s3 sync $monitor_path s3://"$bucket_name"/ --no-progress --region "$bucket_region" --storage-class "$storage_class"
fi

if bashio::var.true "${delete_local_backups}"; then
    bashio::log.info "Will delete local backups except the '${local_backups_to_keep}' newest ones."
    backup_slugs="$(bashio::api.supervisor "GET" "/backups" "false" "$jq_filter")"
    bashio::log.debug "Backups to delete: '$backup_slugs'"

    for s in $backup_slugs; do
        bashio::log.info "Deleting Backup: '$s'"
        bashio::api.supervisor "DELETE" "/backups/$s"
    done
else
    bashio::log.info "Will not delete any local backups since 'delete_local_backups' is set to 'false'"
fi

bashio::log.info "Finished Amazon S3 Backup."