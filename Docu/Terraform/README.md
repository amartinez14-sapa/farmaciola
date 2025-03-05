# Instal·lació de Terraform Client a Ubuntu

Aquesta guia proporciona els passos necessaris per instal·lar Terraform Client en un sistema Ubuntu i inclou un exemple de configuració per a Proxmox.

# Instal·lació de Terraform Client a Ubuntu

Aquesta guia proporciona els passos necessaris per instal·lar Terraform Client en un sistema Ubuntu.

## Requisits previs

Abans de començar, assegura't que tens accés a un usuari amb privilegis d'administrador i que el sistema estigui actualitzat.

## Passos d'instal·lació

1. **Actualitzar el sistema i instal·lar dependències**  
   ```bash
   sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
   ```
   Aquesta comanda assegura que el sistema estigui actualitzat i instal·la les eines necessàries per gestionar repositoris i claus GPG.

2. **Afegir la clau GPG de HashiCorp**  
   ```bash
   wget -O- https://apt.releases.hashicorp.com/gpg | \
   gpg --dearmor | \
   sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
   ```
   Aquesta comanda descarrega la clau GPG de HashiCorp, la converteix al format adequat i l'emmagatzema al sistema.

3. **Verificar la clau GPG**  
   ```bash
   gpg --no-default-keyring \
   --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
   --fingerprint
   ```
   Amb aquesta comanda es pot verificar que la clau s'ha afegit correctament al sistema.

4. **Afegir el repositori de HashiCorp**  
   ```bash
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
   https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
   sudo tee /etc/apt/sources.list.d/hashicorp.list
   ```
   Aquest pas afegeix el repositori oficial de HashiCorp a la llista de repositoris del sistema.

5. **Actualitzar els paquets del sistema**  
   ```bash
   sudo apt update
   ```
   Això assegura que el sistema reconeix el nou repositori i carrega les últimes versions disponibles.

6. **Instal·lar Terraform**  
   ```bash
   sudo apt-get install terraform
   ```
   Finalment, aquesta comanda instal·la Terraform al sistema.

## Verificació de la instal·lació

Per confirmar que Terraform s'ha instal·lat correctament, executa la següent comanda:
```bash
terraform --version
```
Aquesta comanda hauria de mostrar la versió instal·lada de Terraform.

## Exemple de configuració de Terraform per a Proxmox

Un cop instal·lat Terraform, pots crear un fitxer anomenat `main.tf` amb el contingut següent per gestionar **contenidors LXC** a Proxmox:

```hcl
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

  # Afegir la clau SSH al contenidor
  ssh_public_keys = file("~/.ssh/id_rsa.pub")
}
```

Després de guardar aquest fitxer, executa:

```bash
terraform init
terraform plan
terraform apply
```

Això **inicialitzarà** el directori de treball, comprovarà si hi ha canvis respecte al teu entorn i, finalment, desplegarà els recursos indicats a Proxmox.