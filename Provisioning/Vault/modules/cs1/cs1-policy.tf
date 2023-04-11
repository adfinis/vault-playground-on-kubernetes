
locals {
  cs1-policies = fileset(path.root, "${path.module}/cs1-policies/*.hcl")
}

resource "vault_policy" "cs1-policy" {
  namespace = vault_namespace.cs1-ns1.path
  for_each  = local.cs1-policies
  name      = split(".", basename(each.value))[0]
  policy    = file(each.value)
}
