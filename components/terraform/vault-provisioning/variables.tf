variable "VAULT_TOKEN"{
    type = string
    description = "Vault token"
}

variable "VAULT_ADDR"{
    type = string
    default = "https://vault-cli.playground.lab"
    description = "Vault address"
}