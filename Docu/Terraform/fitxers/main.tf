terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.73.1"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.1.5:8006/"
  username  = "root@pam"
  password  = "Contraseña"
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "debian_vm" {
  # Indica quantes VMs vols crear
  count = 3
  # Afegeix un sufix o prefix al nom per evitar col·lisions
  name      = "test-debian-${count.index + 1}"
  node_name = "pv1"

  machine         = "q35"
  bios            = "ovmf"
  stop_on_destroy = true

  # Exemple de cloud-init
  initialization {
    user_account {
      username = "user"
      password = "1234"
      keys     = [file("~/.ssh/id_rsa.pub")]
    }
    ip_config {
      ipv4 {
        # Pots modificar l'adreça IP de forma dinàmica si et convé
        address = "192.168.1.${220 + count.index}/24"
        gateway = "192.168.1.1"
      }
    }
  }

  # Definició de la NIC de xarxa
  network_device {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  # CPU
  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  # RAM en MB
  memory {
    dedicated = 4096
  }

  # Configuració del disc
  disk {
    datastore_id = "Datos"
    file_id      = "local:iso/jammy-server-cloudimg-amd64.img"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 16
    file_format  = "raw"
  }
}
