{
  lib,
  pkgs,
  config,
  ...
}:

{
  config = lib.mkIf config.homelab.enable {
    services.caddy = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
