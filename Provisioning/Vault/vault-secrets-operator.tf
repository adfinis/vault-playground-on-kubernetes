resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

# Use local service account token and CA cert
# https://developer.hashicorp.com/vault/docs/auth/kubernetes
resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://kubernetes.default.svc"
}

resource "vault_kubernetes_auth_backend_role" "default" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "default"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["tenant-1"]
  token_policies                   = ["default", "nginx-demo"]
  token_ttl                        = 1200 #20m
}

resource "vault_policy" "nginx-demo" {
  name     = "nginx-demo"
  policy   = <<EOT
path "pki/*" {
  capabilities = ["read", "create", "update"]
}
EOT
}

resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
}

resource "vault_pki_secret_backend_root_cert" "example" {
  backend              = vault_mount.pki.path
  type                 = "internal"
  common_name          = "RootOrg Root CA"
}

resource "vault_pki_secret_backend_role" "role" {
  backend          = vault_mount.pki.path
  name             = "nginx"
  ttl              = 60
  allowed_domains  = ["example.com", "localhost"]
  allow_subdomains = true
}

# This is an example for a workload agnhost fetching a TLS certificate from Vault
# https://raw.githubusercontent.com/hashicorp/vault-secrets-operator/main/config/samples/secrets_v1alpha1_vaultpkisecret_tls.yaml
resource "kubernetes_manifest" "vaultpkisecret" {
  manifest = yamldecode(file("./manifests/vaultpkisecret.yaml"))
}
resource "kubernetes_manifest" "pod" {
  manifest = yamldecode(file("./manifests/pod.yaml"))
}
resource "kubernetes_manifest" "service" {
  manifest = yamldecode(file("./manifests/service.yaml"))
}
resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(file("./manifests/ingress.yaml"))
}
resource "kubernetes_manifest" "vaultconnection" {
  manifest = yamldecode(file("./manifests/vaultconnection.yaml"))
}
resource "kubernetes_manifest" "vaultauth" {
  manifest = yamldecode(file("./manifests/vaultauth.yaml"))
}

