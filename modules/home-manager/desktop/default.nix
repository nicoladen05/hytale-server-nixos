{ lib, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./gnome.nix
    ./mako.nix
    ./rofi.nix
    ./waybar.nix
    ./yazi.nix
    ./zathura.nix
  ];
}
