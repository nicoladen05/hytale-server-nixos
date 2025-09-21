{ lib, ... }:

{
  imports = [
    ./jellyfin.nix
    ./arr.nix
    ./sabnzbd.nix
  ];

  options.homelab.services.media = {
    enable = lib.mkEnableOption "Enable Media Stack";
  };
}
