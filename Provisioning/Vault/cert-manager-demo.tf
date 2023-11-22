# This is an example for a demo app with Ingress for demonstrating cert-manager
# + Vault PKI/ACME capabilities

locals {
  manifests = fileset("./manifests/cert-manager-demo", "*.yaml")
}

resource "kubernetes_manifest" "vault-cert-manager-demo" {
  computed_fields = ["spec.rules", ]
  for_each = local.manifests
  manifest = yamldecode(file("./manifests/cert-manager-demo/${each.value}"))
}

# Prepare PKI for ACME
resource "vault_generic_endpoint" "enable-acme" {
  path                 = "${vault_mount.pki.path}/config/acme"
  ignore_absent_fields = true
  disable_delete       = true
  write_fields         = ["enabled"]
  data_json            = <<EOT
{
  "enabled": "true"
}
EOT
}

resource "vault_generic_endpoint" "config-acme" {
  path                 = "${vault_mount.pki.path}/config/cluster"
  ignore_absent_fields = true
  disable_delete       = true
  write_fields         = ["path", "aia_path"]
  data_json            = <<EOT
{
  "path": "https://vault.vault.svc.cluster.local:8200/v1/${vault_mount.pki.path}",
  "aia_path": "https://vault.vault.svc.cluster.local:8200/v1/${vault_mount.pki.path}"
}
EOT
}

# Enable Authority Information Access (AIA) templating
# https://developer.hashicorp.com/vault/api-docs/secret/pki#enable_templating
resource "vault_generic_endpoint" "config-urls-templating" {
  path                 = "${vault_mount.pki.path}/config/urls"
  ignore_absent_fields = true
  disable_delete       = true
  write_fields         = ["enable_templating"]
  data_json            = <<EOT
{
  "enable_templating": "true"
}
EOT
}

# Configure the Authority Information Access (AIA)
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_config_urls
resource "vault_pki_secret_backend_config_urls" "config-urls" {
  backend = vault_mount.pki.path
  issuing_certificates = [
    "{{cluster_aia_path}}/issuer/{{issuer_id}}/pem",
  ]
  crl_distribution_points = [
    "{{cluster_aia_path}}/issuer/{{issuer_id}}/crl/pem",
  ]
}

resource "vault_generic_endpoint" "acme-headers" {
  path                 = "sys/mounts/${vault_mount.pki.path}/tune"
  ignore_absent_fields = true
  disable_delete       = true
  write_fields         = ["passthrough_request_headers", "allowed_response_headers", "audit_non_hmac_request_keys", "audit_non_hmac_response_keys"]
  data_json            = <<EOT
{
  "passthrough_request_headers": "If-Modified-Since",
  "allowed_response_headers": ["Last-Modified", "Location", "Replay-Nonce", "Link"],
  "audit_non_hmac_request_keys": ["crl", "csr", "certificate", "issuer_ref", "common_name", "alt_names", "other_sans", "ip_sans", "uri_sans", "ttl", "not_after", "serial_number", "key_type", "private_key_format", "managed_key_name", "managed_key_id", "ou", "organization", "country", "locality", "province", "street_address", "postal_code", "permitted_dns_domains", "policy_identifiers", "ext_key_usage_oids"],
  "audit_non_hmac_response_keys": ["certificate", "issuing_ca", "serial_number", "error", "ca_chain"]
}
EOT
}
