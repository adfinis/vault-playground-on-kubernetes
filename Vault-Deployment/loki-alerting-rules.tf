# Loki alerting and recording rules
resource "kubernetes_manifest" "loki-alerting-rules" {
  manifest = yamldecode(file("./manifests/loki-alerting-rules/vault-audit-rules.yaml"))
  depends_on = [helm_release.loki]
}