{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager
    ../../modules/nixos/nvf.nix
  ];

  home.packages = with pkgs; [
    neovim
    eza
  ];

  nvf.enable = true;

  home-manager = {
    enable = true;

    terminal.enable = true;
    yazi.enable = true;

  };
}
