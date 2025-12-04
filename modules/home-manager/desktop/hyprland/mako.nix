{ lib, pkgs, config, ... }:

{
  options = {
    home-manager.mako.enable = lib.mkEnableOption "enable mako";
  };

  config = lib.mkIf config.home-manager.mako.enable {
    services.mako = {
      enable = true;

      settings = {
        anchor = "top-center";
        border-radius = 10;
        border-size = 2;
        default-timeout = 5000;
        icons = true;
        layer = "overlay";
        margin = "6";
      };
    };
  };
}
