{
  lib,
  config,
  ...
}:

{
  config = lib.mkIf config.homelab.external {
    services.caddy = {
      enable = true;
      acmeCA = "https://acme-v02.api.letsencrypt.org/directory";
      email = "acme@nicoladen.dev";
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
