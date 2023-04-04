terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.14.0"
    }
  }
}

provider "vault" {
  token = var.VAULT_TOKEN
  token_name = "terraform_root"
  address = var.VAULT_ADDR
  skip_tls_verify = true

}