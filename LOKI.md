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
rules](https://grafana.com/docs/loki/latest/alert) for logs. This sounds
tempting at first, but can be computationally expensive when not configured
correctly.

For computationally expensive rules it is suggested to define [recording
rules](https://grafana.com/docs/loki/latest/alert/). These rules precompute and
store the query results as a metric in Prometheus. Afterward, the alert can
then be setup as [Grafana alert rules (with Prometheus
datasource)](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/file-provisioning/#import-alert-rules)
instead of Loki alert rules that would directly query the logs.

Note that Grafana and Loki alerting rules follow a different schema and query
language (`logql` vs `promql`):
* [Loki rule YAML examples](https://grafana.com/docs/loki/latest/alert)
* [Grafana rule YAML examples](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/file-provisioning)

Loki recording rule that generates a metric in Prometheus based on occurrences
of certain keywords in audit logs (note, this is `logql`):
```yaml
groups:
    - name: vault-requests
    rules:
        - record: vault:requests:rate1m
        expr: |
            sum(rate({application="vault"} |~ "\"type\":\"request\"" [1m]))
```

The above rule set needs to be configured on Loki (pods).

This recorded rule generates the metric `vault:requests:rate1m` in Prometheus,
which can be reused to create an alert in Grafana. Because the alert is based
on the already existing metric (in Prometheus), the alert processing in Loki
itself is much lighter/faster.

Alerts in Grafana can be configured in the UI or through [YAML mounted to
Grafana
(pods)](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/file-provisioning/#import-alert-rules)
on path `/etc/grafana/provisioning/alerting/`.


Configure (mount) the actual alerting rules to Grafana. Helm example
([kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml)
chart):
```yaml
grafana:
  extraConfigmapMounts:
  - name: prometheus-alerting-rules
    mountPath: /etc/grafana/provisioning/alerting/
    configMap: prometheus-alerting-rules
    readOnly: true
```

The `promql` style alerting rule for Grafana could look as follows (note, this
schema is different from the alerting schema for Loki above):
```yaml
groups:
  - name: Requests
    folder: Vault
    interval: 1m
    rules:
        # uid required, but can be any uuid
      - uid: 76e4fa8e-4367-4556-b76d-4d6253a3a820
        title: Vault requests soo dangerous
        condition: A
        data:
          - refId: A
            relativeTimeRange:
              from: 600
              to: 0
            datasourceUid: prometheus
            model:
              # reuse recording rule metric
              expr: sum(rate(vault:requests:rate1m[5m])) >= 0
              instant: true
              range: false
              refId: A
        for: 5m
```

`local` storage of the recording rules on the file system of the Loki instance
only allows to read the rules. This is a read-only filesystem which is
populated from a PVC once during the start of the ruler.

Similar applies to the `/etc/grafana/provisioning/` mount in Grafana.

Therefore, restart Loki and Grafana to check the results.
