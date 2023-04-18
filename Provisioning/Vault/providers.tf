provider "vault" {
  token           = var.VAULT_TOKEN
  token_name      = "terraform_root"
  address         = var.VAULT_ADDR
  skip_tls_verify = true

}

provider "kubernetes" {
  config_path    = var.kubeconfig
  config_context = var.kubecontext
}
