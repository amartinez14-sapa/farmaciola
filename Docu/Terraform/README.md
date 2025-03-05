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