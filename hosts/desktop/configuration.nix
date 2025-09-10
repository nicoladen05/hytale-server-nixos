{
  config,
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
    hyprland.enable = true;

    # Colors
    stylix = {
      enable = true;
      colorScheme = "material";
      wallpaper = "https://images.unsplash.com/photo-1756567579531-405e4df07572?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=kristaps-ungurs-4orvBonHMGk-unsplash.jpg";
      wallpaperHash = "sha256-NvkaN3xoQNlg0ieonWl88EFoxiJ3RtMghDamNFZMXYc=";
    };
  };

  # Gaming
  gaming.enable = true;
  gaming.controller.xbox.enable = true;

  nvf.enable = true;

  system.stateVersion = "24.05";
}
