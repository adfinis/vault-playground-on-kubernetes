path "kvv2/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "sys/mounts" {
    capabilities = ["read"]
}
