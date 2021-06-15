terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "terraform-cloud-ta-dcnm"
    }
  }
  required_providers {
    dcnm = {
      source = "CiscoDevNet/dcnm"
      # version = "0.0.5"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      # version = "1.24.2"
    }
    vault = {
      source = "hashicorp/vault"
      # version = "2.18.0"
    }
  }
}

# ### Vault Provider ###
# ## Username & Password provided by Workspace Variable
# variable dcnm_username {}
# variable dcnm_password {
#   sensitive = true
# }
# variable dcnm_url {}
