# Loki
The Loki instance gathers Vault server and audit logs:
* Vault server logs are collected by promtail
* Vault audit logs are pushed from the OpenTelemetry Collector

## Example queries
The server logs can be queried from the promtail data source in Grafana. The
logs have the label `app=vault`.  Example query:
```promql
{app="vault"}
```

The audit logs are queried from the audit log data source in Grafana. This Loki
datasource is populated with data from the OpenTelemetry Collector. Audit logs
have the label `application=vault`. Example query:
```promql
{application="vault"}
```

## Alerting and recording rules
Loki allows you to define [alert
rules](https://grafana.com/docs/loki/latest/alert) for logs.

For computationally expensive rules it is suggested to also define [recording
rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules).
These rules precompute and store the query results as a metric in Prometheus.
As a result, the queries in Loki are faster and more efficient.

Example alerting and corresponding recording rule for alerting on Vault audit
logs:
```yaml
# rules.yaml
groups:
    - name: vault-requests
    rules:
        - alert: HighPercentageVaultRequests
        expr: |
            sum(rate({application="vault"} |~ "\"type\":\"request\"" [1m])) >= 0
        for: 1m
        labels:
            severity: critical
        annotations:
            summary: High percentage of Vault requests
        - record: vault:requests:rate1m
        expr: |
            sum(rate({application="vault"} |~ "\"type\":\"request\"" [1m]))
```
