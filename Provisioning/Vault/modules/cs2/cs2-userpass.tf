resource "vault_auth_backend" "cs2-userpass" {
  type      = "userpass"
  namespace = vault_namespace.cs2-ns1.path
}

resource "random_password" "password" {
  length  = 12
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "vault_generic_endpoint" "cs2-u0" {
  depends_on           = [vault_auth_backend.cs2-userpass]
  path                 = "auth/userpass/users/alice"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs2-ns1.path

  data_json = <<EOT
{
  "policies": ["admin", "default"],
  "password": "${random_password.password.result}"
}
EOT
}

resource "vault_generic_endpoint" "cs2-u1" {
  depends_on           = [vault_auth_backend.cs2-userpass]
  path                 = "auth/userpass/users/bob"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs2-ns1.path

  data_json = <<EOT
{
  "policies": ["kv-r", "default"],
  "password": "${random_password.password.result}"
}
EOT
}


resource "vault_generic_endpoint" "cs2-u2" {
  depends_on           = [vault_auth_backend.cs2-userpass]
  path                 = "auth/userpass/users/peter"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs2-ns1.path

  data_json = <<EOT
{
  "policies": ["kv-rw", "default"],
  "password": "${random_password.password.result}"
}
EOT
}

resource "vault_generic_endpoint" "cs2-u3" {
  depends_on           = [vault_auth_backend.cs2-userpass]
  path                 = "auth/userpass/users/paul"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs2-ns1.path

  data_json = <<EOT
{
  "policies": ["default"],
  "password": "${random_password.password.result}"
}
EOT
}
