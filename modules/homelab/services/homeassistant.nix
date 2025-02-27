{ pkgs, lib, config, ... }:

{
  options = {
    homeassistant.enable = lib.mkEnableOption "enables homeassistant";
  };

  config = lib.mkIf config.homeassistant.enable {
    networking.firewall.allowedTCPPorts = [ 8123 ];

    services.home-assistant = {
      enable = true;

      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
      ];

      config = {
        default_config = {};
      };
    };

  };
}
