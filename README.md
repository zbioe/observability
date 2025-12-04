# Observability Playground

Repository to test observability stack.

Improved for NixOS using Docker in rootless mode.

# Requirements

- docker
- docker-compose

## Components 
- Grafana (Dashboard UI) `:3000`
- Prometheus (Time-series database for metrics) `:9090`
- Loki (Log aggregation) `:3100`
- Node Exporter (Hardware/OS Metrics) `:9100`
- Alloy (Log collector) 
- Flog (Fake log generator for testing) 

# Run
defaults (1 flog)

```sh
docker-compose up
```

to disable Flog

``` sh
FLOG_COUNT=0 docker-compose up
```

to more flogs

``` sh
FLOG_COUNT=3 docker-compose up
```

