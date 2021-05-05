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
      version = "0.0.5"
    }
  }
}

### Vault Provider ###
## Username & Password provided by Workspace Variable
variable dcnm_username {}
variable dcnm_password {
  sensitive = true
}
variable dcnm_url {}

## If using DCNM to assign VNIs use -parallelism=1

provider "dcnm" {
  # cisco-dcnm user name
  username = var.dcnm_username
  # cisco-dcnm password
  password = var.dcnm_password
  # cisco-dcnm url
  url      = var.dcnm_url
  insecure = true
}

data "dcnm_inventory" "DC3-N9K1" {
  fabric_name = "DC3"
  switch_name = "DC3-N9K1"
}

data "dcnm_inventory" "DC3-N9K2" {
  fabric_name = "DC3"
  switch_name = "DC3-N9K2"
}

resource "dcnm_vrf" "tfcb-vrf-1" {
  fabric_name             = "DC3"
  name                    = "tfcb-vrf-1"
  vlan_id                 = 2601
  segment_id              = 52601
  vlan_name               = "tfcb-vrf-1"
  description             = "Terraform Cloud VRF #1"
  intf_description        = "tfcb-vrf-1"
  # tag                     = "1250"
  # max_bgp_path            = 2
  # max_ibgp_path           = 4
  # trm_enable              = false
  # rp_external_flag        = true
  # rp_address              = "1.2.3.4"
  # loopback_id             = 15
  # multicast_address       = "10.0.0.2"
  # multicast_group         = "224.0.0.1/4"
  # ipv6_link_local_flag    = "true"
  # trm_bgw_msite_flag      = true
  advertise_host_route    = true
  # advertise_default_route = true
  # static_default_route    = false
  deploy                  = true
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K1.serial_number
    # vlan_id       = 2300
    attach        = true
    # loopback_id   = 70
    # loopback_ipv4 = "1.2.3.4"
  }
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K2.serial_number
    # vlan_id       = 2300
    attach        = true
    # loopback_id   = 70
    # loopback_ipv4 = "1.2.3.4"
  }
}


resource "dcnm_vrf" "tfcb-vrf-2" {
  fabric_name             = "DC3"
  name                    = "tfcb-vrf-2"
  vlan_id                 = 2602
  segment_id              = 52602
  vlan_name               = "tfcb-vrf-2"
  description             = "Terraform Cloud VRF #2"
  intf_description        = "tfcb-vrf-2"
  # tag                     = "1250"
  # max_bgp_path            = 2
  # max_ibgp_path           = 4
  # trm_enable              = false
  # rp_external_flag        = true
  # rp_address              = "1.2.3.4"
  # loopback_id             = 15
  # multicast_address       = "10.0.0.2"
  # multicast_group         = "224.0.0.1/4"
  # ipv6_link_local_flag    = "true"
  # trm_bgw_msite_flag      = true
  advertise_host_route    = true
  # advertise_default_route = true
  # static_default_route    = false
  deploy                  = true
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K1.serial_number
    # vlan_id       = 2300
    attach        = true
    # loopback_id   = 70
    # loopback_ipv4 = "1.2.3.4"
  }
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K2.serial_number
    # vlan_id       = 2300
    attach        = true
    # loopback_id   = 70
    # loopback_ipv4 = "1.2.3.4"
  }
}

resource "dcnm_network" "tfcb-net-1" {
  fabric_name     = "DC3"
  name            = "tfcb-net-1"
  network_id      = 31601
  display_name    = "tfcb-net-1"
  description     = "L3 VXLAN Network #1. Created by Terraform Cloud"
  vrf_name        = dcnm_vrf.tfcb-vrf-1.name
  vlan_id         = 1601
  vlan_name       = "tfcb-net-1"
  ipv4_gateway    = "192.168.31.1/24"
  # ipv6_gateway    = "2001:db8::1/64"
  # mtu             = 1500
  # secondary_gw_1  = "192.0.3.1/24"
  # secondary_gw_2  = "192.0.3.1/24"
  # arp_supp_flag   = true
  # ir_enable_flag  = false
  # mcast_group     = "239.1.2.2"
  # dhcp_1          = "1.2.3.4"
  # dhcp_2          = "1.2.3.5"
  # dhcp_vrf        = "VRF1012"
  # loopback_id     = 100
  # tag             = "1400"
  # rt_both_flag    = true
  # trm_enable_flag = true
  l3_gateway_flag = true
  deploy = true
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K1.serial_number
    # vlan_id       = 2400
    attach        = true
    switch_ports = ["Ethernet1/1"]
  }
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K2.serial_number
    # vlan_id       = 2500
    attach        = true
    switch_ports = ["Ethernet1/1"]
  }
}

resource "dcnm_network" "tfcb-net-2" {
  fabric_name     = "DC3"
  name            = "tfcb-net-2"
  network_id      = 31602
  display_name    = "tfcb-net-2"
  description     = "L3 VXLAN Network #2. Created by Terraform Cloud 3"
  vrf_name        = dcnm_vrf.tfcb-vrf-1.name
  vlan_id         = 1602
  vlan_name       = "tfcb-net-2"
  ipv4_gateway    = "192.168.32.1/24"
  # ipv6_gateway    = "2001:db8::1/64"
  # mtu             = 1500
  # secondary_gw_1  = "192.0.3.1/24"
  # secondary_gw_2  = "192.0.3.1/24"
  # arp_supp_flag   = true
  # ir_enable_flag  = false
  # mcast_group     = "239.1.2.2"
  # dhcp_1          = "1.2.3.4"
  # dhcp_2          = "1.2.3.5"
  # dhcp_vrf        = "VRF1012"
  # loopback_id     = 100
  # tag             = "1400"
  # rt_both_flag    = true
  # trm_enable_flag = true
  l3_gateway_flag = true
  deploy = true
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K1.serial_number
    # vlan_id       = 2400
    attach        = true
    switch_ports = ["Ethernet1/1"]
  }
  attachments {
    serial_number = data.dcnm_inventory.DC3-N9K2.serial_number
    # vlan_id       = 2500
    attach        = true
    switch_ports = ["Ethernet1/1"]
  }
}
