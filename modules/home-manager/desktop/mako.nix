{ lib, pkgs, config, ... }:

{
  options = {
    home-manager.mako.enable = lib.mkEnableOption "enable mako";
  };

  config = lib.mkIf config.home-manager.mako.enable {
    services.mako = {
      enable = true;

      anchor = "top-center";
      borderRadius = 10;
      borderSize = 2;
      defaultTimeout = 5000;
      icons = true;
      layer = "overlay";
      margin = "6";
    };
  };
}
