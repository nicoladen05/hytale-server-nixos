# AGENTS.md - Agent Guide for NixOS Configuration Repository

This document provides guidelines for agentic coding agents working with this NixOS configuration repository.

## Build/Deploy/Test Commands

Keep in mind that you are likely deploying to remote hosts.

### System Rebuilding
```bash
# Test configuration without switching
sudo nixos-rebuild test --flake .#<host>

# Build configuration only
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

### Deployment
```bash
# Deploy to remote hosts
nix develop -c deploy .#server
nix develop -c deploy .#vps
```

### Development Environment
```bash
# Enter development shell
nix develop

# Update flake inputs
nix flake update

# Check flake
nix flake check
```

### Testing
**No formal test suite exists**. Use these methods instead:
- `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` for dry-run testing
- Manual verification of deployed services
- Check service status on the remote host: `ssh <ip> systemctl status <service>`

## Code Style Guidelines

### File Structure and Naming
- **Files**: Use `kebab-case.nix` (e.g., `desktop.nix`, `gaming.nix`)
- **Directories**: Use lowercase names (e.g., `hosts/`, `modules/`)
- **Host configurations**: Named after machine (e.g., `desktop/`, `server/`, `vps/`)

### Nix Expression Style
- **Indentation**: 2 spaces (no tabs)
- **Module options**: Use `camelCase` (e.g., `baseDomain`, `enableGaming`)
- **Attribute sets**: One attribute per line for complex structures
- **Lists**: One item per line for long lists

### Module Structure Pattern
```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  options.homelab = {
    enable = mkEnableOption "enable homelab configuration";
    
    baseDomain = mkOption {
      type = types.str;
      example = "example.com";
      description = "Base domain for homelab services";
    };
  };

  config = mkIf cfg.enable {
    # Configuration here
  };
}
```

### Import Patterns
```nix
# Standard module imports
imports = [
  ./desktop
  ./gaming
  ./system
  ./programs
];

# Flake inputs
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
};
```

### Configuration Patterns
- **Conditional config**: Always use `mkIf` for enabling features
- **Options**: Always provide `description` and `example` where applicable
- **Services**: Use `systemd.user.services` for user services, `systemd.services` for system services
- **Packages**: User packages go in `home.packages`, system packages in `environment.systemPackages`

### Error Handling
- Use `lib.optionals` for conditional list inclusion
- Validate inputs with proper types (`types.str`, `types.bool`, `types.submodule`)
- Provide meaningful error messages in option descriptions

## Repository Conventions

### Module Organization
- `modules/nixos/`: System-level NixOS modules
- `modules/home-manager/`: Home Manager configurations
- `modules/homelab/`: Reusable homelab service modules
- `packages/`: Custom package definitions
- `overlays/`: Nixpkgs overlays

### Host Configuration Structure
```
hosts/<hostname>/
├── configuration.nix           # Main host configuration
├── hardware-configuration.nix  # Hardware-specific settings
├── home.nix              # Home Manager configuration
└── disko.nix             # Disk configuration (if needed)
```

### Secrets Management
- Use SOPS for encrypted secrets in `secrets/`
- Never commit plaintext secrets
- Use proper file permissions for secret files

### Service Configuration
- Homelab services should be modular and configurable
- Include proper systemd service definitions
- Use `virtualisation.oci-containers` for Docker containers
- Configure networking with appropriate firewall rules

## Development Guidelines

### Adding New Services
1. Create module in `modules/homelab/`, `modules/nixos/`, or `modules/home-manager/` as appropriate
2. Import the module in the host configuration and enable it
3. Include proper options and validation
4. Test with `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` before switching

### Adding New Hosts
1. Create directory under `hosts/`
2. Copy `hardware-configuration.nix` from target
3. Add to `flake.nix` outputs
4. Configure deployment in `deploy-rs` if needed

### Updating Dependencies
- Update inputs: `nix flake update`
- Check for breaking changes in inputs
- Test on non-critical hosts first
- Commit updated `flake.lock`

## Common Patterns

### Impermanence Integration
```nix
environment.persistence."/persist" = {
  directories = [
    "/var/log"
    "/var/lib"
  ];
  files = [
    "/etc/machine-id"
  ];
};
```

### User Service Pattern
```nix
systemd.user.services.my-service = {
  Unit = {
    Description = "My custom service";
  };
  Service = {
    ExecStart = "${pkgs.my-package}/bin/my-service";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "default.target" ];
  };
};
```

### Container Service Pattern
```nix
virtualisation.oci-containers.containers.my-app = {
  image = "docker.io/library/my-app:latest";
  ports = [ "8080:80" ];
  environment = {
    ENV_VAR = "value";
  };
};
```

## Tools Integration

### Deploy-RS
- Configured for remote deployments
- Uses SSH keys for authentication
- Supports rollback capabilities

### Stylix
- System-wide theming
- Configure through `stylix.enable`
- Supports GTK, Qt, and console themes

### NVF (Neovim Framework)
- Custom Neovim configuration
- Located in home-manager modules
- Extensible with additional plugins

## CI/CD
- Automatic flake updates via GitHub Actions (daily at 3 AM UTC)
- No formal testing in CI
- Updates committed automatically to main branch
