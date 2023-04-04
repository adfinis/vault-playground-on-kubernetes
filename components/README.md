# Atmos Components

Atmos separates code from configuration (separation of concerns).

Components (the "code") don't know and don't care how and where they will be provisioned.

https://atmos.tools/quick-start/configure-repository

## Terraform Components
* [./terraform/vault-deployment](./terraform/vault-deployment): Code to deploy HashiCorp Vault
* [./terraform/vault-provisioning](./terraform/vault-provisioning): Code to configure HashiCorp Vault

## Helmfile Components
[./helmfile](./helmfile)
