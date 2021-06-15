
### vSphere ESXi Provider
provider "vsphere" {
  user           = data.vault_generic_secret.mel-vcenter.data["user"]
  password       = data.vault_generic_secret.mel-vcenter.data["password"]
  vsphere_server = data.vault_generic_secret.mel-vcenter.data["vsphere_server"]

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

### Existing Data Sources
data "vsphere_datacenter" "datacenter" {
  name = "MEL-DC4"
}

data "vsphere_compute_cluster" "CL1" {
  name          = "CL1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_distributed_virtual_switch" "DVS-DCNM" {
  name          = "DVS-DCNM"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "ubuntuTemplate" {
  name          = "Ubuntu-20.04-Template"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "NIMBLE-DS-1" {
  name          = "NIMBLE-DS-1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


variable "diskSizeWorkaround" {
  default = 20
}

/*
* Port Groups
*
*/

resource "vsphere_distributed_port_group" "tfcb-local1001" {
  name                            = "tf-local1001"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.DVS-DCNM.id
  vlan_id                         = 1001
}

resource "vsphere_distributed_port_group" "tfcb-local1002" {
  name                            = "tf-local1002"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.DVS-DCNM.id
  vlan_id                         = 1002
}

/*
* DEMO VMs
*/

### Host 1
resource "vsphere_virtual_machine" "tfcb-dcnm-host1" {
  name             = "tfcb-dcnm-host1"
  resource_pool_id = data.vsphere_compute_cluster.CL1.resource_pool_id
  datastore_id     = data.vsphere_datastore.NIMBLE-DS-1.id

  num_cpus  = 2
  memory    = 1024
  guest_id  = data.vsphere_virtual_machine.ubuntuTemplate.guest_id
  scsi_type = data.vsphere_virtual_machine.ubuntuTemplate.scsi_type

  network_interface {
    network_id   = vsphere_distributed_port_group.tfcb-local1001.id
    adapter_type = data.vsphere_virtual_machine.ubuntuTemplate.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    # size             = data.vsphere_virtual_machine.ubuntuTemplate.disks.0.size
    size             = var.diskSizeWorkaround
    eagerly_scrub    = data.vsphere_virtual_machine.ubuntuTemplate.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.ubuntuTemplate.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntuTemplate.id

    customize {
      linux_options {
        host_name = "tfcb-dcnm-host1"
        domain    = "mel.ciscolabs.com"
      }

      network_interface {
        ipv4_address = "10.66.209.4"
        ipv4_netmask = 28
      }
      ipv4_gateway = "10.66.209.1"
      dns_server_list = ["64.104.123.245","171.70.168.183"]
    }
  }
}

### Host 1
resource "vsphere_virtual_machine" "tfcb-dcnm-host2" {
  name             = "tfcb-dcnm-host1"
  resource_pool_id = data.vsphere_compute_cluster.CL1.resource_pool_id
  datastore_id     = data.vsphere_datastore.NIMBLE-DS-1.id

  num_cpus  = 2
  memory    = 1024
  guest_id  = data.vsphere_virtual_machine.ubuntuTemplate.guest_id
  scsi_type = data.vsphere_virtual_machine.ubuntuTemplate.scsi_type

  network_interface {
    network_id   = vsphere_distributed_port_group.tfcb-local1002.id
    adapter_type = data.vsphere_virtual_machine.ubuntuTemplate.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    # size             = data.vsphere_virtual_machine.ubuntuTemplate.disks.0.size
    size             = var.diskSizeWorkaround
    eagerly_scrub    = data.vsphere_virtual_machine.ubuntuTemplate.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.ubuntuTemplate.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntuTemplate.id

    customize {
      linux_options {
        host_name = "tfcb-dcnm-host2"
        domain    = "mel.ciscolabs.com"
      }

      network_interface {
        ipv4_address = "10.66.209.12"
        ipv4_netmask = 28
      }
      ipv4_gateway = "10.66.209.9"
      dns_server_list = ["64.104.123.245","171.70.168.183"]
    }
  }
}
