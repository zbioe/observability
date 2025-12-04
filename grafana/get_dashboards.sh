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

# Alloy
cat <<'EOF' > "$TARGET_DIR/alloy_health.json"
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": null,
  "links": [],
  "panels": [
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 0 },
      "id": 99,
      "panels": [],
      "title": "Health & Resource Usage",
      "type": "row"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": { "defaults": { "color": { "mode": "thresholds" }, "thresholds": { "mode": "absolute", "steps": [ { "color": "red", "value": null }, { "color": "green", "value": 1 } ] } }, "overrides": [] },
      "gridPos": { "h": 4, "w": 8, "x": 0, "y": 1 },
      "id": 1,
      "options": { "colorMode": "value", "graphMode": "area", "justifyMode": "auto", "reduceOptions": { "calcs": [ "lastNotNull" ], "fields": "", "values": false } },
      "targets": [ { "expr": "up{job=\"alloy\"}", "legendFormat": "Status", "refId": "A" } ],
      "title": "Alloy Status (1 = UP)",
      "type": "stat"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "unit": "bytes" }, "overrides": [] },
      "gridPos": { "h": 4, "w": 8, "x": 8, "y": 1 },
      "id": 2,
      "targets": [ { "expr": "process_resident_memory_bytes{job=\"alloy\"}", "legendFormat": "RAM", "refId": "A" } ],
      "title": "Memory Usage",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "unit": "percentunit" }, "overrides": [] },
      "gridPos": { "h": 4, "w": 8, "x": 16, "y": 1 },
      "id": 3,
      "targets": [ { "expr": "rate(process_cpu_seconds_total{job=\"alloy\"}[1m])", "legendFormat": "CPU", "refId": "A" } ],
      "title": "CPU Usage",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 5 },
      "id": 98,
      "panels": [],
      "title": "Logs Analysis",
      "type": "row"
    },
{
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 9 },
      "id": 4,
      "title": "Go Runtime Metrics",
      "type": "row",
      "collapsed": false
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "unit": "short" } },
      "gridPos": { "h": 8, "w": 8, "x": 0, "y": 10 },
      "id": 5,
      "targets": [
        {
          "expr": "go_goroutines{job=\"alloy\"}",
          "legendFormat": "Goroutines",
          "refId": "A"
        }
      ],
      "title": "Goroutines",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "unit": "bytes" } },
      "gridPos": { "h": 8, "w": 8, "x": 8, "y": 10 },
      "id": 6,
      "targets": [
        {
          "expr": "go_memstats_heap_inuse_bytes{job=\"alloy\"}",
          "legendFormat": "Heap In Use",
          "refId": "A"
        }
      ],
      "title": "Memory (Heap)",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "unit": "hz" } },
      "gridPos": { "h": 8, "w": 8, "x": 16, "y": 10 },
      "id": 7,
      "targets": [
        {
          "expr": "rate(go_gc_duration_seconds_count{job=\"alloy\"}[1m])",
          "legendFormat": "GC Rate",
          "refId": "A"
        }
      ],
      "title": "Garbage Collections / Sec",
      "type": "timeseries"
    },
    {
      "datasource": "Loki",
      "fieldConfig": { "defaults": { "color": { "mode": "thresholds" }, "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null }, { "color": "red", "value": 1 } ] } }, "overrides": [] },
      "gridPos": { "h": 6, "w": 5, "x": 0, "y": 6 },
      "id": 4,
      "options": { "colorMode": "background", "graphMode": "none", "justifyMode": "auto", "reduceOptions": { "calcs": [ "lastNotNull" ], "fields": "", "values": false } },
      "targets": [
        {
          "expr": "count_over_time({container_name=~\".*alloy.*\"} |= \"\\\"level\\\":\\\"error\\\"\" [$__range])",
          "legendFormat": "Errors",
          "queryType": "instant",
          "refId": "A"
        }
      ],
      "title": "Total Errors",
      "type": "stat"
    },
    {
      "datasource": "Loki",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "custom": { "drawStyle": "bars", "fillOpacity": 100 }, "mappings": [] }, "overrides": [] },
      "gridPos": { "h": 6, "w": 13, "x": 5, "y": 6 },
      "id": 5,
      "options": { "legend": { "calcs": [], "displayMode": "list", "placement": "bottom", "showLegend": true }, "tooltip": { "mode": "single", "sort": "none" } },
      "targets": [
        {
          "expr": "sum by (level) (count_over_time({container_name=~\".*alloy.*\"} | regexp \"(?P<json_content>[{].*)\" | line_format \"{{.json_content}}\" | json | __error__=\"\" [$__interval]))",
          "legendFormat": "{{level}}",
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "Log Volume by Severity",
      "type": "timeseries"
    },
    {
      "datasource": "Loki",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" } }, "overrides": [] },
      "gridPos": { "h": 6, "w": 6, "x": 18, "y": 6 },
      "id": 8,
      "options": { "legend": { "displayMode": "list", "placement": "right", "showLegend": true }, "pieType": "donut", "reduceOptions": { "calcs": [ "lastNotNull" ], "fields": "", "values": false }, "tooltip": { "mode": "single", "sort": "none" } },
      "targets": [
        {
          "expr": "sum by (level) (count_over_time({container_name=~\".*alloy.*\"} | regexp \"(?P<json_content>[{].*)\" | line_format \"{{.json_content}}\" | json | __error__=\"\" [$__range]))",
          "legendFormat": "{{level}}",
          "queryType": "range",
          "refId": "A"
        }
      ],
      "title": "Level Distribution",
      "type": "piechart"
    },
     {
      "collapsed": false,
      "gridPos": { "h": 1, "w": 24, "x": 0, "y": 22 },
      "id": 97,
      "panels": [],
      "title": "Pipeline Performance",
      "type": "row"
    },
    {
      "datasource": "Prometheus",
      "description": "How many lines of logs is Alloy processing from other containers?",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "custom": { "drawStyle": "line", "fillOpacity": 10 }, "unit": "short" }, "overrides": [] },
      "gridPos": { "h": 6, "w": 24, "x": 0, "y": 23 },
      "id": 7,
      "targets": [ { "expr": "sum(rate(loki_write_sent_entries_total[1m]))", "legendFormat": "Processed Lines / Sec", "refId": "A" } ],
      "title": "Log Processing Speed (Lines/sec)",
      "type": "timeseries"
    },
    {
      "datasource": "Loki",
      "gridPos": { "h": 10, "w": 24, "x": 0, "y": 12 },
      "id": 6,
      "options": { "dedupStrategy": "none", "enableLogDetails": true, "prettifyLogMessage": false, "showCommonLabels": false, "showLabels": false, "showTime": true, "sortOrder": "Descending", "wrapLogMessage": false },
      "targets": [ { "expr": "{container_name=~\".*alloy.*\"} | regexp \"(?P<json_content>[{].*)\" | line_format \"{{.json_content}}\" | json | __error__=\"\"", "refId": "A" } ],
      "title": "Alloy Logs",
      "type": "logs"
    }
  ],
  "schemaVersion": 38,
  "style": "dark",
  "tags": ["alloy", "json"],
  "templating": { "list": [] },
  "time": { "from": "now-3h", "to": "now" },
  "timepicker": {},
  "timezone": "",
  "title": "Alloy Health",
  "uid": "alloy-health",
  "version": 2
}
EOF

# Flog (to test app log generation)
# only runs if has flog in docker-compose
[ "${FLOG_COUNT:-1}" -le 0 ] && exit
cat <<'EOF' > $TARGET_DIR/flog_stats.json
{
  "annotations": { "list": [] },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": null,
  "links": [],
  "panels": [
    {
      "datasource": "loki",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "custom": { "axisCenteredZero": false, "axisColorMode": "text", "axisLabel": "", "axisPlacement": "auto", "barAlignment": 0, "drawStyle": "line", "fillOpacity": 10, "gradientMode": "none", "hideFrom": { "legend": false, "tooltip": false, "viz": false }, "lineInterpolation": "linear", "lineWidth": 1, "pointSize": 5, "scaleDistribution": { "type": "linear" }, "showPoints": "auto", "spanNulls": false, "stacking": { "group": "A", "mode": "none" }, "thresholdsStyle": { "mode": "off" } }, "mappings": [], "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null } ] } }, "overrides": [] },
      "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 },
      "id": 1,
      "options": { "legend": { "calcs": [], "displayMode": "list", "placement": "bottom", "showLegend": true }, "tooltip": { "mode": "single", "sort": "none" } },
      "targets": [
        {
          "datasource": "loki",
          "editorMode": "code",
          "expr": "sum by (status) (count_over_time({container_name=~\".*flog.*\"} | json [1m]))",
          "legendFormat": "Status {{status}}",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Requests by Status Code (Rate)",
      "type": "timeseries"
    },
    {
      "datasource": "loki",
      "fieldConfig": { "defaults": { "color": { "mode": "palette-classic" }, "custom": { "hideFrom": { "legend": false, "tooltip": false, "viz": false } }, "mappings": [] }, "overrides": [] },
      "gridPos": { "h": 8, "w": 12, "x": 12, "y": 0 },
      "id": 2,
      "options": { "legend": { "displayMode": "list", "placement": "right", "showLegend": true }, "pieType": "pie", "reduceOptions": { "calcs": [ "lastNotNull" ], "fields": "", "values": false }, "tooltip": { "mode": "single", "sort": "none" } },
      "targets": [
        {
          "datasource": "loki",
          "editorMode": "code",
          "expr": "sum by (method) (count_over_time({container_name=~\".*flog.*\"} | json [5m]))",
          "legendFormat": "{{method}}",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Top HTTP Methods",
      "type": "piechart"
    },
    {
      "datasource": "loki",
      "gridPos": { "h": 14, "w": 24, "x": 0, "y": 8 },
      "id": 3,
      "options": { "dedupStrategy": "none", "enableLogDetails": true, "prettifyLogMessage": false, "showCommonLabels": false, "showLabels": false, "showTime": true, "sortOrder": "Descending", "wrapLogMessage": false },
      "targets": [
        {
          "datasource": "loki",
          "editorMode": "code",
          "expr": "{container_name=~\".*flog.*\"} | json",
          "refId": "A"
        }
      ],
      "title": "Live Logs (Parsed)",
      "type": "logs"
    }
  ],
  "schemaVersion": 36,
  "style": "dark",
  "tags": ["generated", "flog"],
  "templating": { "list": [] },
  "time": { "from": "now-15m", "to": "now" },
  "timepicker": {},
  "timezone": "",
  "title": "Flog (fake log dashboard)",
  "uid": "flog-stats",
  "version": 1,
  "weekStart": ""
}
EOF
