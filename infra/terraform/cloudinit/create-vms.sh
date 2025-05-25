#!/bin/bash

# Config
VM_IMAGE_PATH="/var/lib/libvirt/images/Fedora-Cloud-Based-Generic-42.1.1.x86_64.qcow2"
CLOUD_INIT_ISO="var/lib/libvirt/images/cloud-init.iso"
NETWORK="default"
RAM="4096"
VCPUS="2"
DISK_SIZE="20G"

# Array of VMs: name, ram, vcpis, disk size
VM_LIST=(
    "vm-k8s-master 4096 2 20G"
    "vm-k8s-node-1 4096 2 20G"
    "vm-k8s-node-2 4096 2 20G"
    "vm-wireguard 1024 1 10G"
)

# Loop through VMs
for entry in "$(VM_LIST[@])"; do
    read -r VM_NAME RAM VCPUS DISK <<< "$entry"

    echo "[+] Creating $VM_NAME"

    virt-install \
        --name "$VM_NAME" \
        --memory "$RAM" \
        --vcpus "$VCPUS" \
        --disk size="$DISK",backing_store="$VM_IMAGE_PATH",format=qcow2 \
        --os-variant fedora-unknown \
        --import \
        --graphics none \
        --network network="$NETWORK",model=virtio \
        --noautoconsole \
        --cloud-init user-data=cloud-init/user-data,meta-data=cloud-init/meta-data
done