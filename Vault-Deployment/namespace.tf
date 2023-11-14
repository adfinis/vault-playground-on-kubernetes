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


resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {
      name = "vault"
    }

    name = "vault"
  }
}


resource "kubernetes_namespace" "tenant-1" {
  metadata {
    annotations = {
      name = "tenant-1"
    }

    name = "tenant-1"
  }
}

resource "kubernetes_namespace" "cert-manager-demo" {
  metadata {
    annotations = {
      name = "cert-manager-demo"
    }

    name = "cert-manager-demo"
  }
}
