resource "vault_auth_backend" "cs1-userpass" {
  type      = "userpass"
  namespace = vault_namespace.cs1-ns1.path
}

resource "random_password" "password" {
  length  = 12
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "vault_generic_endpoint" "cs1-u0" {
  depends_on           = [vault_auth_backend.cs1-userpass]
  path                 = "auth/userpass/users/alice"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs1-ns1.path

  data_json = <<EOT
{
  "policies": ["admin", "default"],
  "${random_password.password.result}"
}
EOT
}


resource "vault_generic_endpoint" "cs1-u1" {
  depends_on           = [vault_auth_backend.cs1-userpass]
  path                 = "auth/userpass/users/bob"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs1-ns1.path

  data_json = <<EOT
{
  "policies": ["kv-r", "default"],
  "${random_password.password.result}"
}
EOT
}


resource "vault_generic_endpoint" "cs1-u2" {
  depends_on           = [vault_auth_backend.cs1-userpass]
  path                 = "auth/userpass/users/peter"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs1-ns1.path

  data_json = <<EOT
{
  "policies": [ "kv-rw", "default"],
  "${random_password.password.result}"
}
EOT
}

resource "vault_generic_endpoint" "cs1-u3" {
  depends_on           = [vault_auth_backend.cs1-userpass]
  path                 = "auth/userpass/users/paul"
  ignore_absent_fields = true
  namespace            = vault_namespace.cs1-ns1.path

  data_json = <<EOT
{
  "policies": ["default"],
  "${random_password.password.result}"
}
EOT
}
