terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
  }
}
