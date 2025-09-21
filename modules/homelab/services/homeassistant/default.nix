{ lib, config, ... }:

let
  cfg = config.homelab.services.homeassistant;
in
{
  # imports = [
  #   ./vm.nix
  # ];

  options = {
    homelab.services.homeassistant = {
      enable = lib.mkEnableOption "enables homeassistant";

      url = lib.mkOption {
        type = lib.types.str;
        default = "home.${config.homelab.baseDomain}";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      extraComponents = [
        # Required for onboarding
        "analytics"
        "google_translate"
        "isal"
        "met"
        "radio_browser"
        "shopping_list"

        # Integrations
        "prusalink"
        "wake_on_lan"
      ] ;
      extraPackages = python3Packages: with python3Packages; [
        pyprusalink
      ];
      config = import ./config.nix;
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
