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
    homelab.services.wireguard.enable = lib.mkEnableOption "enable wireguard vpn";

    homelab.services.wireguard.externalInterface = lib.mkOption {
      type = lib.types.str;
    }

    homelab.services.wireguard.ips = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "IPs and subnets of the server in the tunnel network.";
      default = [ "192.168.255.1/24" ];
    };

    homelab.services.wireguard.port = lib.mkOption {
      type = lib.types.int;
      description = "Port for wireguard to listen on.";
      default = 51820;
    };

    homelab.services.wireguard.privateKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the private key file for the wireguard server.";
      default = "/etc/wireguard/private.key";
    };

    homelab.services.wireguard.peers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            publicKey = lib.mkOption { type = lib.types.str; };
            allowedIPs = lib.mkOption { type = lib.types.listOf lib.types.str; };
            endpoint = lib.mkOption { type = lib.types.listOf lib.types.str; };
          };
        }
      );
      description = "List of allowed peers";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "wireguard" ];

    networking = {
      nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = cfg.externalInterface;
        internalInterfaces = [ "wg0" ];
      };

      firewall.allowedUDPPorts = [ cfg.port ];

      useNetworkd = true;
    };

    systemd.network = {
      enable = true;

      networks."50-wg0" = {
        matchConfig.Name = "wg0";

        address = cfg.ips;

        networkConfig = {  
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };

        routes = [
          { Destination = "192.168.255.0/24"; Gateway = "0.0.0.0"; }
          { Destination = "fd3a:6c4f:1b2e::/64"; Gateway = "::"; }
          { Destination = "2003:e0:17ff:3b42::/64"; Gateway = "::"; }
        ];
      };

      netdevs."50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };

        wireguardConfig = {
          ListenPort = cfg.port;
          PrivateKeyFile = cfg.privateKeyFile;
          # RouteTable = "main";
        };

        wireguardPeers = lib.mapAttrsToList (_: peer: {
          PublicKey = peer.publicKey;
          AllowedIPs = peer.allowedIPs;
          Endpoint = peer.endpoint;
        }) cfg.peers;
      };
    };
  };
}
