provider "vsphere" {
  user           = var.vm_user
  password       = var.vm_password
  vsphere_server = var.vm_server

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "MVMASTER"
}

data "vsphere_resource_pool" "pool" {
  name          = "Bronze"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "MVMASTERSAN"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name                       = "terraform"
  num_cpus                   = 2
  memory                     = 1024
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  guest_id                   = "centos64Guest"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}