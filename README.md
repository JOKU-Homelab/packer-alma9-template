# AlmaLinux 9 Proxmox Template Builder

A professional Packer configuration for building AlmaLinux 9 templates on Proxmox VE using GitHub-hosted kickstart files.

## Overview

This project provides a complete solution for building AlmaLinux 9 virtual machine templates on Proxmox VE using HashiCorp Packer. It's designed to address the common issue where the Packer host is in a different network than the VM being built, by hosting the kickstart file on GitHub instead of relying on Packer's built-in HTTP server.

### Key Features

- **Cross-Network Support**: Uses GitHub-hosted kickstart files instead of Packer's HTTP server
- **UEFI Support**: Configured for modern UEFI boot with secure keys
- **Cloud-Init Ready**: Pre-configured for Cloud-Init integration with Proxmox
- **LVM Partitioning**: Optimized disk layout with Logical Volume Management
- **Well-Documented**: Thoroughly commented code and comprehensive documentation
- **Modular Design**: Separate configuration, variables, and scripts for maintainability

## Requirements

- Proxmox VE 7.0 or higher
- HashiCorp Packer 1.8.0 or higher
- GitHub account for hosting kickstart files
- Internet access from the VM being built (to reach GitHub)
- Proxmox API token with appropriate permissions

## Quick Start

### 1. Prepare GitHub Repository

1. Fork or create a new GitHub repository
2. Upload the contents of this repository, especially the `packer/files/kickstart/ks.cfg` file
3. Ensure the repository is public, or set up authentication if private

### 2. Configure Variables

1. Edit `packer/config/variables.auto.pkrvars.hcl`:
   ```hcl
   github_raw_url = "https://raw.githubusercontent.com/yourusername/yourrepo/main"
   ```

2. Set sensitive variables in your environment:
   ```bash
   export PKR_VAR_proxmox_api_token_secret="your-token-secret"
   export PKR_VAR_vm_root_pw="your-secure-password"
   ```

### 3. Run Packer

```bash
cd packer
packer init almalinux9.pkr.hcl
packer build .
```

## Detailed Documentation

### Network Architecture

This solution works with the following network architectures:

1. **Separate Networks**: Packer host and VM in completely different networks
2. **NAT Environment**: VM behind NAT without direct connectivity to Packer
3. **Air-Gapped Environments**: VM with internet access but no direct route to Packer

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Packer Host │     │   GitHub    │     │   Proxmox   │
│             │────▶│  Repository │◀────│     VM      │
└─────────────┘     └─────────────┘     └─────────────┘
    Triggers            Hosts the          Retrieves
     Build            Kickstart File     Kickstart File
```

### Project Structure

```
packer/                   # Main Packer directory
├── almalinux9.pkr.hcl    # Main Packer configuration file
├── variables.pkr.hcl     # Variable declarations
├── config/               # Configuration files
│   └── variables.auto.pkrvars.hcl  # Variable values (non-sensitive)
├── scripts/              # Shell scripts for provisioning
│   ├── cleanup.sh        # VM cleanup script
│   └── setup-cloud-init.sh  # Cloud-init configuration
└── files/                # Files to be copied to the VM
    └── kickstart/        # Kickstart configuration directory
        └── ks.cfg        # Kickstart configuration file
```
