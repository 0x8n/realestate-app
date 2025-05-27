terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "vm_definitions" {
  type = list(object({
    name    = string
    ram     = number
    vcpus   = number
    disk_gb = number
    ip      = string
  }))
  default = [
    { name = "vm-k8s-master", ram = 4096, vcpus = 2, disk_gb = 20, ip = "192.168.122.10" },
    { name = "vm-k8s-node-1", ram = 4096, vcpus = 2, disk_gb = 20, ip = "192.168.122.11" },
    { name = "vm-k8s-node-2", ram = 4096, vcpus = 2, disk_gb = 20, ip = "192.168.122.12" },
    { name = "vm-wireguard",  ram = 2048, vcpus = 1,  disk_gb = 10, ip = "192.168.122.13" }
  ]
}

resource "libvirt_volume" "disk" {
  for_each = { for vm in var.vm_definitions : vm.name => vm }

  name   = "${each.key}.qcow2"
  pool   = "default"
  source = "images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = { for vm in var.vm_definitions : vm.name => vm }

  name      = "${each.key}-cloudinit.iso"
  user_data = file("${path.module}/cloudinit/user-data")
  meta_data = templatefile("${path.module}/cloudinit/meta-data.tpl", {
    vm_name = each.key
  })
  pool = "default"
}

resource "libvirt_domain" "vm" {
  for_each = { for vm in var.vm_definitions : vm.name => vm }

  name   = each.key
  memory = each.value.ram
  vcpu   = each.value.vcpus

  disk {
    volume_id = libvirt_volume.disk[each.key].id
  }

  network_interface {
    network_name     = "default"
    wait_for_lease   = true
    addresses        = [each.value.ip]
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  console {
    type        = "pty"
    target_port = "0"
  }
}

output "vm_ips" {
  value = [for vm in var.vm_definitions : vm.ip]
}
