# Loki alerting and recording rules
resource "kubernetes_manifest" "loki-alerting-rules" {
  manifest = yamldecode(file("./manifests/loki-alerting-rules/loki-rules.yaml"))
  depends_on = [helm_release.loki]
}

# Prometheus alerting and recording rules
resource "kubernetes_manifest" "prometheus-alerting-rules" {
  manifest = yamldecode(file("./manifests/loki-alerting-rules/prometheus-rules.yaml"))
  depends_on = [helm_release.prometheus-grafana]
}
