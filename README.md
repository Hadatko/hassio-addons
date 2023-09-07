# hassio-addons

Fork from https://github.com/joaofl/hassio-addons
This fork focusing on converting docker stats to hassio. Older implementation should work too.

## telegraf

Mine telegraf settings:

```conf
# Rename measurements, tags, and fields that pass through this filter.
[[processors.rename]]
  ## Specify one sub-table per rename operation.
  [[processors.rename.replace]]
    measurement = "docker_container_cpu"
    dest = "cpu"
  [[processors.rename.replace]]
    measurement = "docker_container_blkio"
    dest = "blkio"
  [[processors.rename.replace]]
    measurement = "docker_container_status"
    dest = "status"
  [[processors.rename.replace]]
    measurement = "docker_container_net"
    dest = "net"
  [[processors.rename.replace]]
    measurement = "docker_container_mem"
    dest = "mem"
# [[outputs.file]]
#   files = ["stdout"]
#   data_format = "json"
[[inputs.docker]]
endpoint = "unix:///var/run/docker.sock"
perdevice = false
perdevice_include = ["cpu", "blkio", "network"]
total = true
total_include = ["cpu", "blkio", "network"]
source_tag = true

[[outputs.mqtt]]
servers = ["mqtt:1883"]
namedrop = ["docker_container_"]
topic = 'telegraf/{{ .PluginName }}_{{ .Tag "container_name" }}'
data_format = "json"
# procotol = "5"
```

## Compose

```yml
  telegrafToHa:
    image: hadatko/telegraf2hassio:latest
    container_name: telegrafToHa
    network_mode: local # depends on your network can be: host, bridge, ... somewhere where telegraf and homeassistant is present
    environment:
      TZ: Europe/Prague
      MQTT_BROKER: mqtt
      TELEGRAF_PLUGIN: docker
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 800M
    restart: unless-stopped
```

## Environment variables

These can be identified from `telegraf2hassio/run.sh script`
