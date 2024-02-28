#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Amazon S3 Backup
# ==============================================================================
#bashio::log.level "debug"

bashio::log.info "Starting Prometheus"

./prometheus --config.file=prometheus.yml