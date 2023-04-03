resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "vault" {
  private_key_pem = tls_private_key.vault.private_key_pem

  subject {
    common_name  = var.commonName
    organization = var.organizationName
  }

  // 10 weeks
  validity_period_hours = 1680

  ip_addresses = ["127.0.0.1"]
  dns_names    = concat(["localhost", "vault", "${var.vault_service_name}", "${var.vault_service_name}.${var.vault_helm_release_name}.svc.${var.cluster_name}", "${var.vault_service_name}.${var.namespace}.svc.${var.cluster_name}", "${var.vault_helm_release_name}"], var.additionalDomains)


  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
    "data_encipherment"
  ]
}


resource "kubernetes_secret" "vault_certs" {
  depends_on = [kubernetes_namespace.playground-namespace]
  metadata {
    name      = "vault-ha-tls"
    namespace = var.namespace
  }
  type = "Opaque"

  data = {
    "vault-playground-cert.key" = tls_private_key.vault.private_key_pem
    "vault-playground-cert.crt" = tls_self_signed_cert.vault.cert_pem
    "vault-playground-cert.ca"  = tls_self_signed_cert.vault.cert_pem
  }

}
