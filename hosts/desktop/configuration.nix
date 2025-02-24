# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, secrets, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default

      # ../../modules/nixos/gnome.nix

      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/stylix.nix

      ../../modules/nixos/default.nix
  ];
  desktop = {
    enable = true;
    userName = "nico";
    hostName = "desktop";
  };

  nvf.enable = true;

  gaming.enable = true;

  vfio.enable = false;

  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "nico" = import ./home.nix;
    };
  };

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true;
  users.users.nico.extraGroups = [ "docker" ];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_MODELS = /home/nico/data/models;
      OLLAMA_HOST = "0.0.0.0";
    };
  };
}
