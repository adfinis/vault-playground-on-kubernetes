# Setup cluster


## Install kubectl

### Linux

#### Debian/Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

#### Red Hat-based distributions

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
```

#### Snap

```bash
sudo snap install kubectl --classic
```

#### Binary

For other Linux distributions or the binary installation method, see the [official documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

### MacOS

#### Homebrew

```bash
brew install kubectl
```

#### Binary

For the binary installation method, see the [official documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/).


### Windows

#### Chocolatey

```bash
choco install kubernetes-cli
```

#### Binary

For the binary installation method, see the [official documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).


## Install Helm

### Linux

#### Debian/Ubuntu

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

#### Red Hat-based distributions

```bash
sudo dnf install helm
```

#### Snap

```bash

sudo snap install helm --classic
```


#### Binary

For other Linux distributions or the binary installation method, see the [official documentation](https://helm.sh/docs/intro/install/).

### MacOS

#### Homebrew

```bash
brew install helm
```

#### Binary

For the binary installation method, see the [official documentation](https://helm.sh/docs/intro/install/).


### Windows

#### Chocolatey

```bash
choco install kubernetes-helm
```

#### Binary

For the binary installation method, see the [official documentation](https://helm.sh/docs/intro/install/).

## Install Terraform

Visit the [official documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform.



## Create Cluster
There a few options to create a cluster. If you don't have a cluster yet, you can use one of the following options:

### Minikube
Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a VM, docker container or on your host. It offers the same features as a full Kubernetes cluster, including DNS, NodePorts, ConfigMaps and Dashboards. Along with the cluster, minikube automatically configures kubectl to communicate with the cluster and offers commands to manage the cluster.

To install minikube, follow the [official documentation](https://minikube.sigs.k8s.io/docs/start/).
After installing minikube, you can create a cluster with the following command:

```bash
minikube start
```
MiniKube will automatically configure kubectl to communicate with the cluster and offers commands to manage the cluster under the context `minikube`.

By default minikube will select docker as the driver. If you want to use a different driver, you can use the `--driver` flag. For more information, see the [official documentation](https://minikube.sigs.k8s.io/docs/drivers/).

If you want to remove the cluster, you can use the following command:

```bash
minikube delete
```


### Kind
Kind is a docker based local Kubernetes cluster. It is a tool for running local Kubernetes clusters using Docker container “nodes”. Kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

To install kind, follow the [official documentation](https://kind.sigs.k8s.io/docs/user/quick-start/).

Create the cluster with the [custom node label and extra port mapping for the Ingress](https://kind.sigs.k8s.io/docs/user/ingress):
```bash
cat <<EOF | kind create cluster --name vault-playground --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

Kind will automatically configure kubectl to communicate with the cluster and offers commands to manage the cluster under the context `kind-vault-playground`.

If you want to remove the cluster, you can use the following command:

```bash
kind delete cluster vault-playground
```

https://kind.sigs.k8s.io/docs/user/quick-start
