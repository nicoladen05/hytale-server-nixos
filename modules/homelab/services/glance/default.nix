{ lib, pkgs, ... }:

let
  cfg = config.homelab.services.glance;
in
{
  options.homelab.services.glance = {
    enable = lib.mkEnableOption "Enable the Glance Dashboard";
  };

  config = lib.mkIf cfg.enable = {
    services.glance = {
      enable = true;
      openFirewall = true;
    };
  };
}