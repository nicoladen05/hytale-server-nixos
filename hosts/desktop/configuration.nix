# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, secrets, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default

      ../../modules/nixos
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nico" = import ./home.nix;
    };
  };

  # CONFIG
  system = {
    enable = true;
    nvidia.enable = true;

    userName = "nico";
    hostName = "desktop";

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
      wallpaper = "https://xcu37g90vd.ufs.sh/f/gISQwWsUpMTPCyMXPPTvFiwZ9rz0MeyfSD2VXAElBUHsoJuT";
      wallpaperHash = "sha256-NduOrnuMG7HcSLVH6Cj6/TIs/fL2kC1gq+O6IGOiEn8=";
    };
  };

  nvf.enable = true;
  gaming.enable = true;
}
