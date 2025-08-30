{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.wireguard;
in
{
  options = {
    cfg.enable = lib.mkEnableOption "enable wireguard vpn";

    cfg.subnet = lib.mkOption {
      type = lib.types.str;
      description = "Subnet of the vpn.";
      default = "192.168.255.0/24";
    };

    cfg.ip = lib.mkOption {
      type = lib.types.str;
      description = "IP and subnet of the server in the tunnel network.";
      default = "192.168.255.1/24";
    };

    cfg.port = lib.mkOption {
      type = lib.types.int;
      description = "Port for wireguard to listen on.";
      default = 51820;
    };

    cfg.privateKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the private key file for the wireguard server.";
      default = "/etc/wireguard/private.key";
    };

    cfg.peers = lib.mkOption {
      type = lib.types.listOf lib.types.set;
      description = "List of allowed peers";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      nat = {
        enable = true;
        externalInterface = "eth0";
        internalInterfaces = [ "wg0" ];
      };

      firewall.allowedTCPPorts = [ 51820 ];

      wireguard = {
        enable = true;
        interfaces = {
          wg0 = {
            ips = [ cfg.ip ];
            listenPort = cfg.port;

            # Allow NAT
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.subnet} -o eth0 -j MASQUERADE
            '';

            # Remove NAT rule on shutdown
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg.subnet} -o eth0 -j MASQUERADE
            '';

            privateKeyFile = cfg.privateKeyFile;

            peers = cfg.peers;
          };
        };
      };
    };
  };
}
