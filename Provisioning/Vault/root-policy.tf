
locals {
  root-policies = fileset(path.root, "root-policies/*.hcl")
}

resource "vault_policy" "root-policies-policy" {
  for_each = local.root-policies
  name     = split(".", basename(each.value))[0]
  policy   = file(each.value)
}
