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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/nixos
    # ../../modules/homelab/services/ollama.nix
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

  networking.networkmanager.dns = "none";
  networking.nameservers = [ "192.168.2.200" ];

  # homelab.services.ollama = {
  #   enable = true;
  #   useCuda = true;
  #   modelDirectory = /home/nico/data/models;
  # };

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

      colorScheme = "black-metal-nile";
      wallpaper = "https://i.ibb.co/HjH3PPk/Witcher-4-Forest-Wallpaper-1.jpg";
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

  # specialisation = {
  #   jovian.configuration = {
  #     gaming = {
  #       jovian.enable = true;
  #       controller.xbox.enable = true;
  #     };
  #   };
  # };

  nvf.enable = true;

  system.stateVersion = "24.05";
}
