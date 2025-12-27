{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.homeassistant;
in
{
  options = {
    homelab.services.code-server = {
      enable = lib.mkEnableOption "Enables VSCode Server";

      url = lib.mkOption {
        type = lib.types.str;
        default = "code.${config.homelab.baseDomain}";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.code-server = {
      enable = true;
      host = "0.0.0.0";
      port = 8443;
    };

    users.users.code-server.packages = [ 
      pkgs.python313.withPackages [
        pkgs.python313Packages.tkinter
      ]
      pkgs.xvfb-run
      pkgs.uv 
    ];

    networking.firewall.allowedTCPPorts = [ 8443 ];
  };
}
