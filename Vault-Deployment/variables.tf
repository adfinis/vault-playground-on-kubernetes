variable "kubeconfig" {
  type = string
}

variable "kubecontext" {
  type = string
}

variable "vault-license" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "vault_helm_release_name" {
  type    = string
  default = "vault"
}

variable "vault_service_name" {
  type    = string
  default = "vault-internal"
}


variable "prometheus-vault-access-token" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type    = string
  default = "cluster.local"
}


variable "organizationName" {
  type    = string
  default = "Test"
}

variable "organizationalUnitName" {
  type    = string
  default = "TestUinit"
}

variable "commonName" {
  type    = string
  default = "vault-internal.svc.cluster.local"
}

variable "additionalDomains" {
  type    = list(string)
  default = []
}
