# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.settings.trusted-users = [ "root" "nico" ];

  # CONFIG
  system = {
    enable = true;
    nvidia.enable = true;
    sops.enable = true;

    userName = "nico";
    hostName = "desktop";
    passwordFile = config.sops.secrets.password.path;

    shell = pkgs.zsh;

    tcpPorts = [ 22 ];
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

    stylix = {
      enable = true;

      colorScheme = "everforest-dark-hard";
      wallpaper = "https://images.unsplash.com/photo-1477322524744-0eece9e79640?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=juan-davila-P8PlK2nGwqA-unsplash.jpg";
      wallpaperHash = "sha256-eISEchJr1/wl+557PdWeG/58uS5sz0SOMqbQAskdess=";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; userName = "${config.system.userName}"; };
    users = {
      "nico" = import ./home.nix;
    };
  };

  nvf.enable = true;
  gaming.enable = true;
}
