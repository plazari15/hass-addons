ARG BUILD_FROM
# amd64: ubuntu:${VERSION}
# i386: i386/ubuntu:${VERSION}
# aarch64: arm64v8/ubuntu:${VERSION}
# armv7: arm32v7/ubuntu:${VERSION}

FROM ${BUILD_FROM}
ENV PROMETHEUS_VERSION="2.27.1"


COPY run.sh /
RUN chmod a+x /run.sh

RUN apk add --no-cache wget \
    && wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz \
    && tar -xvzf prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz \
    && mv prometheus-${PROMETHEUS_VERSION}.linux-armv7 prometheus \
    && rm prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz \
    && apk del wget

WORKDIR /prometheus

COPY prometheus.yml /prometheus/

# Porta que o Prometheus vai utilizar
EXPOSE 9090

# Comando para iniciar o Prometheus
#CMD [ "./prometheus", "--config.file=prometheus.yml" ]

HEALTHCHECK \
    CMD curl --fail http://127.0.0.1:9090 || exit 1

CMD ["/run.sh"]
