{ lib, config, ... }:

{
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./stylix.nix
    ./audio.nix
  ];
}
