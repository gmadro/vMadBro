resource "vsphere_virtual_machine" "vm" {
  name                       = var.vm_name
  num_cpus                   = var.vm_cpus
  memory                     = var.vm_mem
  resource_pool_id           = var.vm_rp_id
  datastore_id               = var.vm_ds_id
  guest_id                   = var.vm_guest_id
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = var.vm_net_id
  }

  disk {
    label = var.vm_disk_label
    size  = var.vm_disk_size
  }
}