# STAGE 1 - Copy
FROM alpine:3.18.3 as orig

RUN apk add git

RUN git clone https://github.com/Hadatko/hassio-addons.git

# STAGE 2 - Final
FROM alpine:3.18.3

WORKDIR /

RUN apk update && apk add --no-cache bash python3 py3-pip bash  && \
                            rm -rf /var/cache/apk/*
RUN pip3 install --no-cache paho-mqtt

RUN mkdir -p /opt/telegraf2hassio

COPY --from=orig /hassio-addons/telegraf2hassio/source /opt/telegraf2hassio/
COPY --from=orig /hassio-addons/telegraf2hassio/run.sh /opt/telegraf2hassio/
RUN chmod a+x /opt/telegraf2hassio/run.sh

CMD ["bash", "-c","/opt/telegraf2hassio/run.sh"]
