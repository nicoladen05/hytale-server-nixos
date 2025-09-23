{
    config,
    lib,
    network,
    ...
}:

let
    userName = "nico";
    hostName = "server";
in
{
  imports = [
      ./hardware-configuration.nix
      ./disko.nix

      ../../modules/nixos
      ../../modules/homelab
  ];

  # System configuration
  system = {
      enable = true;
      sops.enable = true;

      # User account
      inherit userName;
      inherit hostName;
      password = {
          enable = true;
          hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
      };
      passwordlessRebuild = true;
      ssh.enable = true;
      tcpPorts = [ 22 ];
  };

  # Homelab
  homelab = {
    enable = true;
    external = true;

    baseDomain = "nicoladen.dev";

    services = {
      backup = {
        enable = true;
        repositoryFile = config.sops.secrets."restic/repository".path;
        passwordFile = config.sops.secrets."restic/password".path;
        environmentFile = config.sops.secrets."restic/environment".path;
      };

      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
      };

      botify = {
        enable = true;
        tokenFile = config.sops.secrets."services/botify/token".path;
      };

      blocky = {
        enable = true;
        settings = {
          blockLists = (import ../../configs/network/blocklists.nix);
          clients = lib.mapAttrs (_: c: [ c.ip ]) (import ../../configs/network/clients.nix);
          blockGroups = {
            default = [ "ads" "security" ];
          };
        };
      };

      immich = {
        enable = true;
        hardwareAcceleration = true;
        mediaLocation = "/data/immich";
      };

      homeassistant.enable = true;

      vaultwarden.enable = true;

      ocis.enable = true;

      n8n.enable = true;

      wireguard = {
        enable = true;
        ips = [
          "192.168.255.1/32"
          "fd3a:6c4f:1b2e::1/128"
          "2003:e0:17ff:3b42::1/128"
        ];
        privateKeyFile = config.sops.secrets."wireguard/privkey".path;
        peers = {
          phone = {
            PublicKey = "HUJGJf2uFa8p8EpwQNS5ZKz06qIQOd1uquA8zGkB1Ag=";
            AllowedIPs = ["0.0.0.0/0" "::/128"];
            Endpoint = "ddns.nicoladen.dev:51820";
          };
        };
      };
    };
  };

  # Static ip
  networking = {
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "192.168.2.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.2.1";
      interface = "enp1s0";
    };
  };

  # Users
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5BIr0SEPaA6JLVriI5tpbiOORp6qE+D25uqEEY+BvtAwUxpn8PWo33il8bw1aD8HUptiToPBFHcx3H7TL2o1O+b1kADvfOsCSfZM2bATp1fZ6zkzeSpApG5Ahu5CgpZnL+PMwIyeY4o2G/iRLGyF9Q3+edyhBOX+jbbdW9Xht35nne87/3rUCoiXXXLK6vwY5FIFxNzxU/40JWVhdlbXSvXVVPpx+eNnnJcOdUWGcDIk6ozLihZW21uwmwnfHN99ndibAMF0GHB+lPBIe9GGJHF/KQHJI4glz7Dta0pI30BHR2ZXaEVXI265NTVdY0tKqsoT5bwOeJ+14tivkpnXfbxpBBCx3n/Cts/Rs3PCBCCKzhxvNdx5S08dF/5xQXMzoYRABbMPVxqDvjnNY8chhDlLkfDv9vEE44llzuBwSby83n0Ikn9NVn3Q5vbbZYYpS96agYdbiL0ia65TfMyIKVRfx+YLG6YtDYRuf1qvxsZsWrfi2BvXUvYx/+PaelW+lp0O5/3BFZSId4Bk25Z73lwEaucWw/Z2zim0C425o++Tu0u3tVkvglFgs2kbVJUpXn9gtxzihU0bW7sF8LuuUkg0LL/mcpR3q445I1W3AVcayuWCd3GCWRN/Aw22d3egVbVv2Ku7FrEUelBXupfo4NO9UqUlcNj/04WQb34jZKQ== nico@desktop"
  ];
  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}
