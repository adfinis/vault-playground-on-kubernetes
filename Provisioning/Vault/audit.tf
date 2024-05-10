resource "vault_audit" "stdout" {
  type = "file"

  options = {
    file_path = "stdout"
  }
}

resource "vault_audit" "otel" {
  type  = "socket"
  path  = "otel_socket"

  options = {
    address     = "opentelemetry-collector.otlp.svc.cluster.local:54525"
    socket_type = "tcp"
  }
}
