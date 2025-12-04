{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  userName = "nico";
  hostName = "desktop";
in

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Home Manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs userName;
    };
    users = {
      "${userName}" = import ./home.nix;
    };
  };

  # Impermanence
  programs.fuse.userAllowOther = true;
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  # System configuration
  system = {
    # Essentials
    enable = true;
    nvidia.enable = true;
    sops.enable = true;

    # User account
    inherit userName;
    inherit hostName;
    password = {
      enable = true;
      hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
    };
    passwordlessRebuild = true;

    shell = pkgs.zsh;

    # Extra settings
    bluetooth.enable = true;

    # Firewall
    tcpPorts = [ 22 ];
    udpPorts = [ ];
  };

  # Automount disks
  services.udisks2.enable = true;

  # Package sets
  packages = {
    enable = true;
    terminal.enable = true;
    coding.enable = true;
    desktop.enable = true;
    gaming.enable = true;
    productivity.enable = true;
  };

  # Graphical configuration
  desktop = {
    audio.enable = true;
    kde.enable = true;

    # Colors
    stylix = {
      enable = true;
      colorScheme = "catppuccin-mocha";
      wallpaper = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/keyboard.png";
      wallpaperHash = "sha256-IUkujJbnij/Xa79oCo+92dKcpEOpsF2pBPIvLB1+OWQ=";
    };
  };

  # Users
  users.users.nico.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.nico.hashedPasswordFile = lib.mkForce null;
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  # Gaming
  gaming.enable = true;
  gaming.controller.xbox.enable = true;

  nvf.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];

  system.stateVersion = "24.05";
}
