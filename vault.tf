### Vault Provider ###
## Username & Password provided by Workspace Variable
variable vault_username {}
variable vault_password {
  sensitive = true
}

provider "vault" {
  address = "https://Hashi-Vault-1F899TQ4290I3-1824033843.ap-southeast-2.elb.amazonaws.com"
  skip_tls_verify = true
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}

### DCNM Secrets ###
data "vault_generic_secret" "mel-dcnm" {
  path = "kv/mel-dcnm"
}

### vCenter Secrets ###
data "vault_generic_secret" "mel-vcenter" {
  path = "kv/mel-vcenter"
}
