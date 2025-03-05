terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://pve1.almaru.es:8006/api2/json"
  pm_api_token_id     = "tf_user@pve!terraform"
  pm_api_token_secret = "b2443db6-4c99-4c2f-b2c4-cc62689522f5"
  pm_tls_insecure     = true
}

resource "proxmox_lxc" "test_server" {
  count    = 3
  hostname = "mytest-${count.index + 1}"
  vmid     = count.index + 4001
  target_node = "pv1"
  ostemplate  = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  unprivileged = true

  cores  = 2
  memory = 4096

  rootfs {
    storage = "Datos"
    size    = "16G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.${count.index + 200}/24"
    gw     = "192.168.1.1"
  }

  start = true

  # Agregar clave SSH al contenedor
  ssh_public_keys = file("~/.ssh/id_rsa.pub")
  }