ARG BUILD_FROM
FROM $BUILD_FROM

ARG \
    PYTHON_VERSION \
    PIP_VERSION \
    GPG_KEY \
    QEMU_CPU

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

COPY run.sh /
RUN chmod a+x /run.sh

RUN apk add -v --update --no-cache \
        python3 \
        py3-pip \
        groff \
        less \
        jq \
        && \
    pip install mktxp

COPY mktxp.conf /home/mktxp/mktxp/mktxp.conf
COPY _mktxp.conf /home/mktxp/mktxp/_mktxp.conf

EXPOSE 49090
RUN addgroup -S mktxp && adduser -S mktxp -G mktxp
USER mktxp
#CMD ["mktxp", "export"]
CMD ["/run.sh"]
#CMD tail -f /dev/null
