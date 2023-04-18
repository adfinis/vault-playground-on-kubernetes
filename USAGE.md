# Usage Instructions

**This is a development environment and should not be used in production!**

## 1. Setup Kubernetes Cluster with Helm and Terraform
Follow the [Setup instructions](SETUP.md) to setup a Kubernetes cluster with Helm.

## 2. Vault Enterprise License
Retrieve a [Vault Enterprise trial license](https://www.hashicorp.com/products/vault/trial).

## 3. Setup environment
Fill in the necessary information in the `./Vault-Deployment/terraform.tfvars` file.
Set your namespace:
```bash
export VAULT_K8S_NAMESPACE=<your namespace>
```

## 4. Enable ingress

### 4.1. Minikube
Run the following commands to enable ingress:
```bash

minikube addons enable ingress

kubectl patch deployment -n ingress-nginx ingress-nginx-controller --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value":"--enable-ssl-passthrough"}]'
```
### 4.2. Kind
[Deploy Metallb](https://kind.sigs.k8s.io/docs/user/loadbalancer) to use an IP in the Docker network (below assumes range `172.19.255.200 - 172.19.255.250`) for load balancing purposes:

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/config/manifests/metallb-native.yaml
kubectl apply -f https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml
```

Deploy Nginx Ingress and patch it to enable ssl passthrough:

```bash
# apply suggested defaults for kind
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# change ingress service type to loadbalancer
kubectl patch svc -n ingress-nginx ingress-nginx-controller --type='json' -p='[{"op": "replace", "path": "/spec/type", "value":"LoadBalancer"}]'

# remove --publish-status-address=localhost, don't set loadbalancer status to localhost (will use IP of ingress)
kubectl patch deployment -n ingress-nginx ingress-nginx-controller --type='json' -p='[{"op": "remove", "path": "/spec/template/spec/containers/0/args/9"}]'

# enable ssl passthrough
kubectl patch deployment -n ingress-nginx ingress-nginx-controller --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value":"--enable-ssl-passthrough"}]'
```

## 5. Deploy Vault
Run the following commands to deploy Vault:
```bash
cd Vault-Deployment
terraform init
terraform apply
```

## 6. Unseal Vault
Run the following commands to unseal Vault:
```bash
kubectl exec -n vault vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > ./cluster-keys.json
kubectl exec -n vault vault-0 -- vault operator unseal $(cat ./cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl exec -n vault vault-1 -- vault operator unseal $(cat ./cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl exec -n vault vault-2 -- vault operator unseal $(cat ./cluster-keys.json | jq -r ".unseal_keys_b64[]")
```
## 7. Login to Vault
Run the following commands to login to Vault:
```bash
./add-to-hosts.sh

export VAULT_ADDR=https://vault-cli.playground.lab

export VAULT_TOKEN=$(cat cluster-keys.json | jq -r .root_token)

export VAULT_SKIP_VERIFY=true

vault login $VAULT_TOKEN
```

## 8. Create token for Prometheus

The Vault /sys/metrics endpoint is authenticated. Prometheus requires a Vault token with sufficient capabilities to successfully consume metrics from the endpoint.

Define a prometheus-metrics ACL policy that grants read capabilities to the metrics endpoint.

```bash
vault policy write prometheus-metrics - << EOF
path "/sys/metrics" {
  capabilities = ["read"]
}
EOF
```

Create token with the prometheus-metrics policy attached that Prometheus will use for authentication to access the Vault telemetry metrics endpoint.

Write the token ID to the file prometheus-token in the Prometheus configuration directory.

```bash
vault token create \
  -field=token \
  -policy prometheus-metrics \
  > ./prometheus-token
```

Now we need to update the data of the secret "prometheus-monitoring-token" in Kubernetes with the new token.

```bash
sed -i "s/prometheus-vault-access-token =.*/prometheus-vault-access-token = \"$(cat prometheus-token)\"/g" terraform.tfvars
terraform apply
```

Now restart the Prometheus pod to pick up the new token.

```bash
kubectl delete pod prometheus-kube-stack-prometheus-kube-prometheus-0
```

## 9. Access Playground

Go to http://explore.playground.lab/ to get an overview over all applications.

## 10. Provisioning Vault

Export the Vault token to the environment variable `TF_VAR_VAULT_TOKEN`:
```bash
export TF_VAR_VAULT_TOKEN=$(cat cluster-keys.json | jq -r .root_token)
```

Switch to the `Provisioning/Vault` directory.
Then run the following commands to provision Vault:
```bash
terraform init
terraform apply
```
