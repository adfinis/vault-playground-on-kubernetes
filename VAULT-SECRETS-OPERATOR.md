# Vault Secrets Operator

The `Provisioning/Vault` scripts deploy the [Vault Secrets
Operator](https://github.com/hashicorp/vault-secrets-operator) to the
`vault-secrets-operator` namespace.

The sample [Ingress TLS with
VaultPKISecret](https://github.com/hashicorp/vault-secrets-operator#ingress-tls-with-vaultpkisecret)
is configured for testing purposes.

## Test for Correctness

To test that the secrets operator was installed correctly, issue the following
curl against the Ingress and watch the TTL of the certificate change every two
minutes:
```bash
curl -kvI https://localhost/tls-app/hostname
```
