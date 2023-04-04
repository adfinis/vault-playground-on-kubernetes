resource "time_sleep" "vault-sleep" {
  depends_on = [helm_release.vault]

  create_duration = "30s"
}


resource "kubernetes_ingress_v1" "vault-ui-ingress" {
  depends_on = [time_sleep.vault-sleep]
  metadata {
    name = "vault-ui-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
      "kubernetes.io/ingress.class"                 = "nginx"
    }
  }
  spec {
    rule {
      host = "vault-ui.playground.lab"
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "vault-ui"
              port {
                number = 8200
              }
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_ingress_v1" "vault-cli-ingress" {
  depends_on = [time_sleep.vault-sleep]

  metadata {
    name = "vault-cli-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
      "kubernetes.io/ingress.class"                 = "nginx"
    }
  }
  spec {
    rule {
      host = "vault-cli.playground.lab"
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "vault"
              port {
                number = 8200
              }
            }
          }
        }
      }
    }
  }
}



resource "time_sleep" "prometheus-grafana-sleep" {
  depends_on = [helm_release.prometheus-grafana]

  create_duration = "30s"
}




resource "kubernetes_ingress_v1" "prometheus-ingress" {
  depends_on = [time_sleep.prometheus-grafana-sleep]
  metadata {
    name = "prometheus-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
      "kubernetes.io/ingress.class"                 = "nginx"
    }
  }
  spec {
    rule {
      host = "prometheus.playground.lab"
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "kube-stack-prometheus-kube-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "grafana-ingress" {
  depends_on = [time_sleep.prometheus-grafana-sleep]
  metadata {
    name = "grafana-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
      "kubernetes.io/ingress.class"                 = "nginx"
    }
  }
  spec {
    rule {
      host = "grafana.playground.lab"
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "kube-stack-prometheus-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

