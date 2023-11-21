
resource "kubernetes_secret" "vault_licence" {
  metadata {
    name      = "hashicorp-vault-license"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
  type = "Opaque"

  data = {
    "license.hclic" = var.vault-license
  }
}



resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  # version    = var.vault_helm_chart_version
  namespace = kubernetes_namespace.vault.metadata[0].name
  wait      = false

  values = [
    "${templatefile("./values/vault-values.yaml", {})}"
  ]

  depends_on = [
    kubernetes_namespace.playground-namespace,
    kubernetes_secret.vault_certs,
    kubernetes_secret.vault_licence,
    kubernetes_secret.prometheus-monitoring-token,
    helm_release.prometheus-grafana,

  ]
}

resource "helm_release" "vault-secrets-operator" {
  name       = "vault-secrets-operator"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault-secrets-operator"
  create_namespace = true
  namespace  = "vault-secrets-operator"
  version    = "0.4.0"
  wait      = false
}


resource "kubernetes_secret" "prometheus-monitoring-token" {
  depends_on = [kubernetes_namespace.playground-namespace]

  metadata {
    name      = "prometheus-monitoring-token"
    namespace = var.namespace
  }
  type = "Opaque"

  data = {
    # Needs to be replaced with a new token after vault is deployed
    "prometheus-token" = var.prometheus-vault-access-token
  }
}


resource "helm_release" "prometheus-grafana" {
  name       = "kube-stack-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  version    = "44.2.1"

  values = [
    file("./values/kube-prometheus-stack-values.yaml")
  ]

  set {
    name  = "prometheus-node-exporter.hostRootFsMount.enabled"
    value = "false"
  }

  depends_on = [
    kubernetes_secret.prometheus-monitoring-token,
    kubernetes_namespace.playground-namespace
  ]


}


resource "helm_release" "open-ldap" {
  name       = "openldap-stack-ha"
  repository = "https://jp-gouin.github.io/helm-openldap/"
  chart      = "openldap-stack-ha"
  namespace  = var.namespace
  wait       = false

  values = [
    file("./values/openldap.yaml")
  ]


  depends_on = [
    kubernetes_namespace.playground-namespace
  ]

}





resource "helm_release" "homer" {
  name       = "homer"
  repository = "https://djjudas21.github.io/charts/"
  chart      = "homer"
  namespace  = var.namespace
  wait       = false

  values = [
    file("./values/homer.yaml")
  ]


  depends_on = [
    kubernetes_namespace.playground-namespace
  ]

}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true
  wait       = false
  version    = "1.13.2"

  values = [
    file("./values/cert-manager.yaml")
  ]
}
