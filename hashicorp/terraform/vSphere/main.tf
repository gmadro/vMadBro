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

module "vm1" {
  source = "./modules/vmware-vm"

  vm_name       = "moduleVM"
  vm_cpus       = 1
  vm_mem        = 1024
  vm_rp_id      = data.vsphere_resource_pool.pool.id
  vm_ds_id      = data.vsphere_datastore.datastore.id
  vm_guest_id   = "centos64Guest"
  vm_net_id     = data.vsphere_network.network.id
  vm_disk_label = "disk0"
  vm_disk_size  = 20
}