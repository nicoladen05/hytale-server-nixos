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
      wallpaper = "https://images.unsplash.com/photo-1739643247007-044e2623ca98?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=marek-piwnicki-HxPkohFqDGY-unsplash.jpg";
      wallpaperHash = "sha256-njjKS0Wh0jd4hIVAWLFiBcZbS+LEy9Err3dIVcNxCxc=";
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
