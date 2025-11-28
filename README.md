# Observability Playground

Repository to test observability environment

# Requirements

- Docker
- docker-compose

## Components 
- Grafana (Dashboard UI) `:3000`
- Prometheus (Time-series database for metrics) `:9090`
- Loki (Log aggregation) `:3100`
- Node Exporter (Hardware/OS Metrics) `:9100`
- Promtail (Log collector) 
- Flog (Fake log generator for testing) 

# Run
```sh
docker-compose up
```
