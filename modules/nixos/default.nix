{ pkgs, lib, ... }:

{
  imports = [
    ./system/nh.nix
    ./server/homeassistant.nix
    ./server/tailscale.nix
    ./server/minecraft-server.nix

    ./virtualisation/default.nix

    ./essentials/nvf.nix
    ./desktop/default.nix

    ./gaming
    
  ];
}
