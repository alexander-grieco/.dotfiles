# Full access, but revocable and auditable, unlike the root token.
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
