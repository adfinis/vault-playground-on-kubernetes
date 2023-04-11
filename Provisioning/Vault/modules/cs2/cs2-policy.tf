
locals {
  cs2-policies = fileset(path.root, "${path.module}/cs2-policies/*.hcl")
}

resource "vault_policy" "cs2-policy" {
  namespace = vault_namespace.cs2-ns1.path
  for_each  = local.cs2-policies
  name      = split(".", basename(each.value))[0]
  policy    = file(each.value)
}
