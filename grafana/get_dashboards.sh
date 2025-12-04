#!/usr/bin/env bash

TARGET_DIR=dashboards

rm $TARGET_DIR/*.json

# Node Exporter
curl -o $TARGET_DIR/node_exporter.json https://grafana.com/api/dashboards/1860/revisions/37/download

sed -i 's/"${datasource}"/"prometheus"/g' "$TARGET_DIR/node_exporter.json"

# Logs
curl -o $TARGET_DIR/logs.json https://grafana.com/api/dashboards/13639/revisions/2/download

sed -i 's/${DS_LOKI}/loki/g' "$TARGET_DIR/logs.json"

sed -i 's/label_values(job)/label_values(container_name)/g' "$TARGET_DIR/logs.json"
sed -i 's/label_values(app)/label_values(container_name)/g' "$TARGET_DIR/logs.json"

sed -i 's/job=\\"$app\\"/container_name=\\"$app\\"/g' "$TARGET_DIR/logs.json"
sed -i 's/job=\\"$job\\"/container_name=\\"$job\\"/g' "$TARGET_DIR/logs.json"

# Prometheus
curl -o $TARGET_DIR/prometheus_stats.json https://grafana.com/api/dashboards/3662/revisions/2/download

sed -i 's/${DS_THEMIS}/prometheus/g' "$TARGET_DIR/prometheus_stats.json"
