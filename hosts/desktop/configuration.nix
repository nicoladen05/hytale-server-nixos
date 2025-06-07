# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/homelab/services/ollama.nix
  ];

  nix.buildMachines = [
    {
      hostName = "eclipse";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      supportedFeatures = ["big-parallel"];
    }
    {
      hostName = "rpi5";
      sshUser = "nico";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.settings.trusted-users = ["root" "nico"];

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

    tcpPorts = [22];
    udpPorts = [];
  };

  homelab.services.ollama = {
    enable = true;
    useCuda = true;
    modelDirectory = /home/nico/data/models;
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

      colorScheme = "gruvbox-material-dark-medium";
      wallpaper = "https://images.unsplash.com/photo-1745669754254-c30c98e5f8b1?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=andrei-r-popescu-HBsmzKuGyuI-unsplash.jpg";
      wallpaperHash = "sha256-C0lvJ0ff0mCC3i9mmeHZsj/n6Ehkp3jaslVr7VDUB3k=";
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

  # specialisation = {
  #   jovian.configuration = {
  #     gaming = {
  #       jovian.enable = true;
  #       controller.xbox.enable = true;
  #     };
  #   };
  # };

  nvf.enable = true;
}
