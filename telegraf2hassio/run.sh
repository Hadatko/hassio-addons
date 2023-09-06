#!/bin/bash
echo "Starting Telegraf2Hassio"

term_handler(){
    echo "Stopping..."
    exit 0
}

# Setup signal handlers
trap 'term_handler' SIGTERM

MQTT_BROKER="${MQTT_BROKER:-localhost}"
MQTT_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-}"
MQTT_PASSWORD="${MQTT_PASSWORD:-}"
TELEGRAF_TOPIC="${TELEGRAF_TOPIC:-telegraf/#}"
TELEGRAF_PLUGIN="${TELEGRAF_PLUGIN:-}"
CALC_RATE=''
LOG_LEVEL="${LOG_LEVEL:-info}"

# Enforces required env variables
required_vars=(MQTT_BROKER MQTT_PORT TELEGRAF_TOPIC)
for required_var in "${required_vars[@]}"; do
    if [[ -z ${!required_var} ]]; then
        echo >&2 "Error: $required_var env variable not set."
        exit 1
    fi
done

python3 /opt/telegraf2hassio/telegraf2hassio.py \
                    --broker-ip=${MQTT_BROKER} \
                    --port=${MQTT_PORT}        \
                    --user=${MQTT_USER}        \
                    --pass=${MQTT_PASS}        \
                    --topic=${TELEGRAF_TOPIC}  \
                    --plugin=${TELEGRAF_PLUGIN}  \
                    --log-level=${LOG_LEVEL}
