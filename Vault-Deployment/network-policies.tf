# Apply Kubernetes network policies to harden tcp communication between namespaces
resource "kubernetes_manifest" "kubernetes-networkpolicy-loki" {
  count    = var.enable_kubernetes_network_policies ? 1 : 0
  manifest = yamldecode(file("./manifests/network-policies/networkpolicy-loki-ingress.yaml"))
}
resource "kubernetes_manifest" "kubernetes-networkpolicy-otlp" {
  count    = var.enable_kubernetes_network_policies ? 1 : 0
  manifest = yamldecode(file("./manifests/network-policies/networkpolicy-otlp-ingress.yaml"))
}

# Apply Cilium network policies to harden tcp communication between namespaces
resource "kubernetes_manifest" "cilium-network-policies" {
  count    = var.enable_cilium_network_policies ? 1 : 0
  manifest = yamldecode(file("./manifests/network-policies/cilium-policies.yaml"))
}