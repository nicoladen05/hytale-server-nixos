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
  ];
  nix.distributedBuilds = true;
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

    tcpPorts = [];
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

      colorScheme = "catppuccin-macchiato";
      wallpaper = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/waves/Waves%20Dark%20Alt%206016x6016.jpg";
      wallpaperHash = "sha256-5hjv4M7LIYCS4AqEf1k2417taqN7hqi4ffCSc+7QzAY=";
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
