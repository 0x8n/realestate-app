#!/bin/bash

VM_NAMES=(
    "vm-k8s-master"
    "vm-k8s-node-1"
    "vm-k8s-node-2"
    "vm-k8s-node-3"
)

for VM in "${VM_NAMES[@]}"; do
    cat > "meta-data-${VM}" <<EOF
instance-id: ${VM}
local-hostname: ${VM}
EOF
done