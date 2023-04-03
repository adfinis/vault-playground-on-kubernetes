data "kubernetes_namespace" "testns-vault" {
  metadata {
    name = var.namespace
  }
}



resource "kubernetes_namespace" "playground-namespace" {
  count = (lookup(data.kubernetes_namespace.testns-vault, "id") != null) ? 0 : 1
  metadata {
    annotations = {
      name = var.namespace
    }

    name = var.namespace
  }
}


