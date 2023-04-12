resource "vault_auth_backend" "root-userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "root-u0" {
  depends_on           = [vault_auth_backend.root-userpass]
  path                 = "auth/userpass/users/admin"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin"],
  "password": "passworld123"
}
EOT
}
