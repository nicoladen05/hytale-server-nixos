# NixOS Configuration

Personal NixOS configuration repository with system configurations for multiple hosts.

## Structure

- `hosts/` - Host-specific configurations
  - `<hostname>/configuration.nix` - Main host configuration
  - `<hostname>/hardware-configuration.nix` - Hardware-specific settings
  - `<hostname>/home.nix` - Home Manager configuration
  - `<hostname>/disko.nix` - Disk configuration (if needed)
- `home/` - Home Manager configurations
- `configs/` - Global configuration files (intended to be modified)
- `modules/` - Reusable NixOS modules
  - `nixos/` - System-level NixOS modules
  - `home-manager/` - Home Manager configurations
  - `homelab/` - Reusable homelab service modules
- `packages/` - Custom package definitions
- `overlays/` - Nixpkgs overlays
- `secrets/` - Encrypted secrets (managed with SOPS)

## Usage

### Building
```bash
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

### Testing
```bash
sudo nixos-rebuild test --flake .#<host>
```

### Deployment
```bash
nix develop -c deploy .#<host>
```

### Development
```bash
nix develop          # Enter development shell
nix flake update     # Update inputs
nix flake check       # Check configuration
```
