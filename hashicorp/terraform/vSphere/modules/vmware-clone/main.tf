data "vsphere_virtual_machine" "template" {
  name          = var.vm_clone_template_name
  datacenter_id = var.vm_clone_dc_id
}

resource "vsphere_virtual_machine" "mod_vm_clone" {
  name                       = var.vm_clone_name
  num_cpus                   = var.vm_clone_cpus
  memory                     = var.vm_clone_mem
  resource_pool_id           = var.vm_clone_rp_id
  datastore_id               = var.vm_clone_ds_id
  guest_id                   = var.vm_clone_guest_id
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = var.vm_clone_net_id
  }

  disk {
    label = var.vm_clone_disk_label
    size  = var.vm_clone_disk_size
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

}