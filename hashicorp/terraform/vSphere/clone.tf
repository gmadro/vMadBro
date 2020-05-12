data "vsphere_virtual_machine" "template" {
  name = "Cent5Base"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm_clone" {
  name                       = "terraform_clone"
  num_cpus                   = 8
  memory                     = 2048
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

  disk {
    label = "disk1"
    size = 20
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}