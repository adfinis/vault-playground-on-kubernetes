# Test network policies
Kubernetes and/or Cilium network policies can be applied by enabling the Terraform variables:
```
enable_kubernetes_network_policies = true
enable_cilium_network_policies = true
```

Ensure Minikube/kind has the network plugin enabled and Cilium CNI installed.

## Positive test
Push test metrics to `vault-audit` Loki tenant from `otlp` namespace:
```bash
kubectl run --rm -it debug --image=curlimages/curl -n otlp -- sh
$ curl -X POST http://loki.loki.svc.cluster.local:3100/loki/api/v1/push -H "X-Scope-OrgID: vault-audit" -H "Content-Type: application/json" --data-raw "{\"streams\": [{ \"stream\": { \"foo\": \"bar2\" }, \"values\": [ [ \"$(date +%s)000000000\", \"fizzbuzz-$(date +%s)\" ] ] }]}"
```

## Negative test
Push test metrics to `vault-audit` Loki tenant from `default` namespace:
```bash
kubectl run --rm -it debug --image=curlimages/curl -n default -- sh
$ curl -X POST http://loki.loki.svc.cluster.local:3100/loki/api/v1/push -H "X-Scope-OrgID: vault-audit" -H "Content-Type: application/json" --data-raw "{\"streams\": [{ \"stream\": { \"foo\": \"bar2\" }, \"values\": [ [ \"$(date +%s)000000000\", \"fizzbuzz-$(date +%s)\" ] ] }]}"
```