 terraform apply
 terraform state
 terraform state show
 terraform state show -state=main.tf
 virsh vol-delete --pool default vm-k8s-node-1-cloudinit.iso
 virsh vol-delete --pool default vm-k8s-node-2-cloudinit.iso
 virsh vol-delete --pool default vm-k8s-master-cloudinit.iso
 virsh vol-delete --pool default vm-k8s-wireguard-cloudinit.iso
 virsh vol-delete --pool default vm-wireguard-cloudinit.iso
 virsh vol-delete vm-k8s-master-cloudinit.iso --pool default
 virsh vol-delete vm-k8s-node-1-cloudinit.iso --pool default
 virsh vol-delete vm-k8s-node-2-cloudinit.iso --pool default
 virsh vol-delete vm-wireguard-cloudinit.iso --pool default
 TF_LOG=DEBUG terraform apply
 TF_LOG=DEBUG terraform init
 TF_LOG=DEBUG terraform plan
 for i in `sudo ls /var/lib/libvirt/images|grep vm`; do rm -rf /var/lib/libvirt/images/$i; done
 terraform init -upgrade
 terraform init 
 terraform plan
 terraform apply
