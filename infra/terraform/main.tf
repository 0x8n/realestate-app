terraform {
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
            version = "~> 0.7.0"
        }
        null = {
            source = "hashicorp/null"
            version = "~> 3.2"
        }
    }
}

provider "libvirt" {
    uri = "qemu:///system"
}

output "vm_names" {
    value = [for vm in libvirt_domain.vm:vm.name]
}

variable "base_image" {
    description = "Relative path to base Fedora image"
    default = "images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
}

locals {
    vm_definitions = [
        { name = "vm-k8s-master", ram = 4096, vcpus = 2, disk = "20G", ip = "192.168.122.10" },
        { name = "vm-k8s-node-1", ram = 4096, vcpus = 2, disk = "20G", ip = "192.168.122.11" },
        { name = "vm-k8s-node-2", ram = 4096, vcpus = 2, disk = "20G", ip = "192.168.122.12" },
        { name = "vm-wireguard", ram = 4096, vcpus = 1, disk = "10G", ip = "192.168.122.13" },
    ]
}

# autogen meta-data files
resource "null_resource" "generate-meta-data" {
    provisioner "local-exec" {
        command = "${path.module}/cloudinit/generate-meta-data.sh"
    }

    triggers = {
        always_run = "${timestamp()}" # forces rerun on every apply
    }
}

# depends on meta-data being present ^^
resource "libvirt_cloudinit_disk" "init" {
    for_each = { for vm in local.vm_definitions : vm.name => vm }

    name = "${each.key}-cloudinit.iso"
    user_data = file("${path.module}/cloudinit/user-data")

    meta_data = templatefile("${path.module}/cloudinit/meta-data.tpl", {
        vm_name = each.key
    })

    pool = "default"

    lifecycle {
        replace_triggered_by = [null_resource.generate-meta-data]
    }
}

resource "libvirt_volume" "vm_disk" {
    for_each = { for vm in local.vm_definitions : vm.name => vm }

    name = "${each.key}.qcow2"
    source = abspath(var.base_image)
    pool = "default"
    format = "qcow2"
}

resource "libvirt_domain" "vm" {
    for_each = { for vm in local.vm_definitions : vm.name => vm }

    name = each.key
    memory = each.value.ram
    vcpu = each.value.vcpus

    console {
        type = "pty"
        target_port = "0"
    }

    disk {
        volume_id = libvirt_volume.vm_disk[each.key].id
    } 

    network_interface {
        network_name = "default"
        wait_for_lease = true
        addresses = [each.value.ip]
    }

    cloudinit = libvirt_cloudinit_disk.init[each.key].id
}