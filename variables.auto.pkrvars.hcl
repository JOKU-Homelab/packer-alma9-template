/*
* AlmaLinux 9 Proxmox Template - Variable Values
* ===========================================
*
* This file contains non-sensitive variable values for the Packer template.
* Sensitive values should be provided via seperate file.
*/

//----------------------------------------------------------------------
// Proxmox Connection Settings
//----------------------------------------------------------------------
proxmox_api_url         = "https://192.168.1.5:8006/api2/json"
proxmox_api_token_id    = "joku@pve!packer"
proxmox_node            = "prdpve01"
proxmox_skip_tls_verify = true  // Change to false in production environments

//----------------------------------------------------------------------
// VM General Configuration
//----------------------------------------------------------------------
vm_id   = "9000"  // Must be unique across the Proxmox cluster
vm_name = "AlmaLinux9-Template"

//----------------------------------------------------------------------
// VM Hardware Configuration
//----------------------------------------------------------------------
vm_cores  = "2"
cpu_type  = "host"  // Uses host CPU features for best performance
vm_memory = "2048"  // In MB

//----------------------------------------------------------------------
// VM Storage Configuration
//----------------------------------------------------------------------
iso_file         = "local:iso/AlmaLinux-9.5-x86_64-minimal.iso"
iso_storage_pool = "local"
storage_pool     = "local-lvm"
disk_size        = "12G"
efi_storage_pool = "local-lvm"

//----------------------------------------------------------------------
// Network Configuration
//----------------------------------------------------------------------
network_bridge = "vmbr0"