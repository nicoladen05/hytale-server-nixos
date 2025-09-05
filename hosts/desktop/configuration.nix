# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  nix.buildMachines = [
    {
      hostName = "server.nicoladen.dev";
      sshUser = "nico";
      system = "aarch64-linux";
      protocol = "ssh";
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.settings = {
    trusted-users = [
      "root"
      "nico"
    ];
    extra-platforms = [ "aarch64-linux" ];
  };

  # CONFIG
  system = {
    enable = true;
    nvidia.enable = true;
    sops.enable = true;

    userName = "nico";
    hostName = "desktop";
    passwordFile = config.sops.secrets.password.path;

    bluetooth.enable = true;

    shell = pkgs.zsh;

    tcpPorts = [ 22 ];
    udpPorts = [ ];
  };

  services.udisks2.enable = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  packages = {
    enable = true;
    terminal.enable = true;
    coding.enable = true;
    desktop.enable = true;
    gaming.enable = true;
    productivity.enable = true;
  };

  desktop = {
    audio.enable = true;
    hyprland.enable = true;
    gnome.enable = false;

    stylix = {
      enable = true;

      colorScheme = "material";
      wallpaper = "https://images.unsplash.com/photo-1756567579531-405e4df07572?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=kristaps-ungurs-4orvBonHMGk-unsplash.jpg";
      wallpaperHash = "sha256-WF3uDkQsV9f/3yiNDQVcE548uwYqrA5T9HBj8URqlr4=";
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      userName = "${config.system.userName}";
    };
    users = {
      "nico" = import ./home.nix;
    };
  };

  gaming.enable = true;
  gaming.controller.xbox.enable = true;

  nvf.enable = true;

  system.stateVersion = "24.05";
}
