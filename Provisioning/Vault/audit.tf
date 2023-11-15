resource "vault_audit" "file" {
  type = "file"

  options = {
    file_path = "stdout"
  }
}