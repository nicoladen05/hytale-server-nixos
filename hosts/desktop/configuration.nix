# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/nixos
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

      colorScheme = "vesper";
      wallpaper = "https://i.redd.it/7vzss3iwq0me1.png";
      wallpaperHash = "sha256-w/2YwyJhR9Kb3Pccs6lcy/NH+iGT5nSsU8XqBurBvvg=";
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
