/*
* AlmaLinux 9 Proxmox Template - Variables
* ======================================
*
* This file contains all variable declarations used in the Packer template.
* Variable values are set in separate .auto.pkrvars.hcl files.
*
* Variable organization:
* 1. Proxmox Connection Variables
* 2. VM General Configuration Variables
* 3. VM Hardware Configuration Variables
* 4. VM Storage Configuration Variables
* 5. Network Configuration Variables
* 6. Security Variables
*/

//----------------------------------------------------------------------
// 1. Proxmox Connection Variables
//----------------------------------------------------------------------

variable "proxmox_api_url" {
  type        = string
  description = "URL for Proxmox VE API (e.g., https://proxmox.example.com:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Token ID for Proxmox API authentication (e.g., root@pam!packer)"
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Secret token for Proxmox API authentication"
}

variable "proxmox_node" {
  type        = string
  description = "Name of the Proxmox node where the VM will be created"
}

variable "proxmox_skip_tls_verify" {
  type        = bool
  default     = true
  description = "Skip TLS verification for Proxmox API (use false in production)"
}

//----------------------------------------------------------------------
// 2. VM General Configuration Variables
//----------------------------------------------------------------------

variable "vm_id" {
  type        = string
  description = "VM ID in Proxmox (must be unique, numeric)"
}

variable "vm_name" {
  type        = string
  description = "Name of the VM template in Proxmox"
}

//----------------------------------------------------------------------
// 3. VM Hardware Configuration Variables
//----------------------------------------------------------------------

variable "vm_cores" {
  type        = string
  description = "Number of CPU cores for the VM"
}

variable "cpu_type" {
  type        = string
  description = "CPU type for the VM (e.g., host, kvm64)"
}

variable "vm_memory" {
  type        = string
  description = "Amount of memory in MB for the VM"
}

//----------------------------------------------------------------------
// 4. VM Storage Configuration Variables
//----------------------------------------------------------------------

variable "iso_file" {
  type        = string
  description = "Path to the ISO file in Proxmox storage (e.g., local:iso/AlmaLinux-9-latest-x86_64-minimal.iso)"
}

variable "iso_storage_pool" {
  type        = string
  description = "Storage pool where the ISO is located"
}

variable "storage_pool" {
  type        = string
  description = "Storage pool for VM disk"
}

variable "disk_size" {
  type        = string
  description = "Size of the VM disk (e.g., 32G)"
}

variable "efi_storage_pool" {
  type        = string
  description = "Storage pool for EFI firmware"
}

//----------------------------------------------------------------------
// 5. Network Configuration Variables
//----------------------------------------------------------------------

variable "network_bridge" {
  type        = string
  description = "Network bridge for the VM (e.g., vmbr0)"
}

//----------------------------------------------------------------------
// 6. Security Variables
//----------------------------------------------------------------------

variable "vm_root_pw" {
  type        = string
  sensitive   = true
  description = "Root password for the VM (should be provided via environment variable)"
}