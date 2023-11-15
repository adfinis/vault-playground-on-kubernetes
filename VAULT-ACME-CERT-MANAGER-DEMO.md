# Vault ACME Cert Manager Demo

The `Provisioning/Vault` scripts deploy a [http echo
service](https://hub.docker.com/r/hashicorp/http-echo/) to the
`cert-manager-demo` namespace.

The sample extends the echo service provided in
[learn-consul-kubernetes](https://github.com/hashicorp/learn-consul-kubernetes/blob/main/mesh-gateways/dc2/static-server.yaml).

An example Ingress is used to showcase the capabilities of the following
components:
* Vault [PKI as ACME
  server](https://developer.hashicorp.com/vault/api-docs/secret/pki#acme-certificate-issuance)
* Cert manager with [annotaded Ingress
  resource](https://cert-manager.io/docs/usage/ingress/)

## Test for Correctness

To test that the cert-manager issued the certificate:
```bash
curl -v -k --resolve example.com:443:192.168.39.145 https://example.com
openssl s_client -connect 192.168.39.145:443 -servername example.com | openssl x509 -noout -text
```

This assumes the IP of the Ingress is `192.168.39.145`.

## Debugging and Troubleshooting

For further inspection of the setup, the following commands might be useful:
```bash
kubectl describe clusterissuer vault-acme-issuer
kubectl describe certificaterequest cert-manager-demo-cert-1 -n cert-manager-demo
kubectl describe certificate -n cert-manager-demo
```

Also, have a look at the [troubleshooting
documentation](https://cert-manager.io/docs/troubleshooting) and the
[certificate
lifecycle](https://cert-manager.io/docs/concepts/certificate/#certificate-lifecycle)
upstream.
