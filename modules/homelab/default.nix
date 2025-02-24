{ lib, ... }:

{
  options.homelab = {
    enable = lib.mkEnableOption "enable homelab configuration"
  };
}
