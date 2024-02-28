ARG BUILD_VERSION
ARG BUILD_FROM
FROM ${BUILD_FROM}

USER root

COPY ./mktxp/ /root/mktxp/

COPY run.sh /mktxp

#ENTRYPOINT ["tail", "-f", "/dev/null"]

CMD ["export"]
