#cloud-config
users:
  - default
  - name: fedora
    ssh-authorized-keys:
      - ${public_ssh_key} 
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    passwd: "$6$rounds=4096$3XmJgTXkJHrB$z7kAjmjoL1V.1Rb7PlDjUvruYq9I1cyzqM0zTHDP6AB1nVoW9A8KzFqpy3zEp4Q8r8ykL2h9sWcnsQL56GHr61"
