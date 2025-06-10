# AlmaLinux 9 Proxmox Template Builder

A professional Packer configuration for building AlmaLinux 9 templates on Proxmox VE with UEFI support, Cloud-Init integration, and automated provisioning.

## Overview

This project provides a complete solution for building AlmaLinux 9 virtual machine templates on Proxmox VE using HashiCorp Packer. The template is designed for production use with modern features including UEFI boot, Cloud-Init support, and comprehensive automation.

### Key Features

- **UEFI Support**: Modern UEFI boot configuration with secure keys
- **Cloud-Init Ready**: Pre-configured for seamless Cloud-Init integration with Proxmox
- **LVM Partitioning**: Optimized disk layout with Logical Volume Management
- **Automated Provisioning**: Complete unattended installation via kickstart
- **Production Ready**: Includes proper cleanup and templating procedures
- **Modular Design**: Well-organized configuration files for easy maintenance
- **Swiss Keyboard Layout**: Pre-configured for Swiss/US keyboard layouts

## Requirements

- **Proxmox VE**: 7.0 or higher
- **HashiCorp Packer**: 1.8.0 or higher
- **AlmaLinux 9 ISO**: Minimal installation ISO
- **API Token**: Proxmox API token with appropriate permissions
- **Network Access**: VM must have internet access during build

## Quick Start

### 1. Download AlmaLinux 9 ISO

Download the AlmaLinux 9 minimal ISO and upload it to your Proxmox storage:

```bash
# Example: Upload to Proxmox local storage
# The ISO should be available as: local:iso/AlmaLinux-9.5-x86_64-minimal.iso
```

### 2. Configure Credentials

1. Copy the credentials template:
   ```bash
   cp credentials.auto.pkrvars.hcl.example credentials.auto.pkrvars.hcl
   ```

2. Edit `credentials.auto.pkrvars.hcl` with your sensitive values:
   ```hcl
   proxmox_api_token_secret = "your-actual-token-secret"
   vm_root_pw = "your-secure-root-password"
   ```

### 3. Configure Variables

Edit `variables.auto.pkrvars.hcl` to match your environment:

```hcl
proxmox_api_url      = "https://your-proxmox-host:8006/api2/json"
proxmox_api_token_id = "your-user@pve!your-token-name"
proxmox_node         = "your-proxmox-node-name"
iso_file            = "local:iso/AlmaLinux-9.5-x86_64-minimal.iso"
```

### 4. Run Packer

```bash
# Initialize Packer plugins
packer init .

# Validate configuration
packer validate .

# Build the template
packer build .
```

## Configuration Files

### Core Files

| File | Purpose |
|------|---------|
| `almalinux9.pkr.hcl` | Main Packer configuration |
| `variables.pkr.hcl` | Variable declarations |
| `variables.auto.pkrvars.hcl` | Non-sensitive variable values |
| `credentials.auto.pkrvars.hcl` | Sensitive credentials (not in repo) |

### Kickstart Configuration

| File | Purpose |
|------|---------|
| `files/kickstart/ks.cfg` | Automated installation configuration |

### Provisioning Scripts

| File | Purpose |
|------|---------|
| `scripts/setup-cloud-init.sh` | Cloud-Init configuration and setup |
| `scripts/cleanup.sh` | Template cleanup and preparation |

## Project Structure

```
.
├── README.md                           # This documentation
├── .gitignore                         # Git ignore rules
├── almalinux9.pkr.hcl                 # Main Packer configuration
├── variables.pkr.hcl                  # Variable declarations
├── variables.auto.pkrvars.hcl         # Non-sensitive variable values
├── credentials.auto.pkrvars.hcl       # Sensitive credentials (create from example)
├── credentials.auto.pkrvars.hcl.example # Credentials template
├── files/
│   └── kickstart/
│       └── ks.cfg                     # Kickstart configuration
└── scripts/
    ├── setup-cloud-init.sh            # Cloud-Init setup script
    └── cleanup.sh                     # Template cleanup script
```

## Template Features

### Operating System Configuration

- **Base OS**: AlmaLinux 9 (Minimal installation)
- **Boot Mode**: UEFI with secure boot keys
- **Partitioning**: LVM with separate `/boot`, `/boot/efi`, root, and swap
- **Keyboard**: Swiss (primary) and US (secondary) layouts
- **Timezone**: Europe/Zurich
- **SELinux**: Enforcing mode
- **Firewall**: Enabled with SSH access

### Installed Packages

**Base packages:**
- Essential system utilities (rsync, tar, zip, curl)
- Network management tools
- Security packages (SELinux policies)

**Cloud integration:**
- cloud-init
- cloud-utils-growpart
- qemu-guest-agent

### Cloud-Init Configuration

The template is pre-configured for Proxmox Cloud-Init with:
- Default user: `cloud-user` (with sudo access)
- SSH key injection support
- Network configuration via Cloud-Init
- Hostname and user management
- Automatic disk expansion

## Customization

### Modifying Hardware Specifications

Edit `variables.auto.pkrvars.hcl`:

```hcl
vm_cores  = "4"        # Number of CPU cores
vm_memory = "4096"     # Memory in MB
disk_size = "20G"      # Disk size
```

### Customizing the Installation

Edit `files/kickstart/ks.cfg` to modify:
- Package selection
- Partitioning scheme
- Network configuration
- User accounts
- System services

### Adding Custom Provisioning

Add additional provisioning steps in `almalinux9.pkr.hcl`:

```hcl
provisioner "shell" {
  inline = [
    "dnf install -y your-custom-package",
    "systemctl enable your-service"
  ]
}
```

## Security Considerations

### Credentials Management

- **Never commit credentials** to version control
- Use the provided `.gitignore` to exclude sensitive files
- Consider using environment variables for sensitive data:
  ```bash
  export PKR_VAR_proxmox_api_token_secret="your-token"
  export PKR_VAR_vm_root_pw="your-password"
  ```

### Template Security

The template includes several security features:
- SSH host key regeneration on first boot
- Machine ID cleanup for unique instances
- SELinux enforcing mode
- Firewall enabled by default
- Root password hashing in kickstart

## Troubleshooting

### Common Issues

**Build fails during kickstart:**
- Verify ISO file path and availability
- Check network connectivity from VM to internet
- Review kickstart syntax in `files/kickstart/ks.cfg`

**Packer HTTP server not accessible:**
- Ensure the HTTP bind address is accessible from the VM network
- Check firewall rules on the Packer host
- Verify the HTTP port range (8000-8100) is available

**Template doesn't boot:**
- Verify UEFI settings in Proxmox
- Check EFI storage pool configuration
- Ensure secure boot keys are properly configured

### Debug Mode

Run Packer with debug output for troubleshooting:

```bash
PACKER_LOG=1 packer build .
```

### Log Files

Check these locations for additional debugging information:
- Packer output and logs
- `/root/ks-post.log` (kickstart post-install log)
- `/var/log/cloud-init-setup.log` (Cloud-Init setup log)
- `/root/template-cleanup.log` (cleanup process log)

## Template Usage

After successful build, the template will be available in Proxmox as VM ID specified in your variables. To use the template:

1. **Clone the template** to create new VMs
2. **Configure Cloud-Init** settings in Proxmox
3. **Customize** hardware specifications as needed
4. **Start** the VM - Cloud-Init will handle initial configuration

### Example Cloud-Init Configuration

In Proxmox, configure Cloud-Init with:
- **User**: Set username and SSH keys
- **Network**: Configure IP settings or use DHCP
- **DNS**: Set DNS servers if needed

## Contributing

When contributing to this project:

1. Test changes thoroughly in a development environment
2. Update documentation for any configuration changes
3. Follow the existing code style and organization
4. Ensure sensitive information is properly excluded from commits

## License

This project is provided as-is for educational and production use. Please ensure compliance with AlmaLinux and other component licenses.
