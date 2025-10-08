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

      code-server.enable = true;

      homeassistant.enable = true;

      vaultwarden.enable = true;

      ocis.enable = true;

      n8n.enable = true;

      wireguard = {
        enable = true;
        externalInterface = "enp1s0";
        ips = [
          "192.168.255.1/32"
          "fd3a:6c4f:1b2e::1/128"
          "2003:e0:17ff:3b42::1/128"
        ];
        privateKeyFile = config.sops.secrets."wireguard/privkey".path;
        peers = {
          phone = {
            publicKey = "HUJGJf2uFa8p8EpwQNS5ZKz06qIQOd1uquA8zGkB1Ag=";
            allowedIPs = ["0.0.0.0/0" "::/128"];
            endpoint = "ddns.nicoladen.dev:51820";
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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXGyUgkeoDxvW+FiwBHqPbtwzvyb5GosDgIaE3uBihImtMZTjEHVKWob8nkMqGqu+ga+axck5F1rwvIDcLufnin3N74D2R6xVa4VwC2DNHThzxoyfDvjxTqvaxAoqnQWLd3IyLKxTgnstdXsOwIgTKtqWcL5g5CvSpsHmxVSQVFlUXpuhM8F8jDr573dpCtBrD7fpkC64Q4hMtWUDch1DLleHLv9Jjf1GYe01sPvrRfzKC5pXnHSXiddOgyzDHnU+MK6vqbETGcrB89ENcFZUveJGON1KfwM9x3JCiP5IVz3Pxam72XKy0eRMUda2ZGgT7EP/KpJA+ESlkT58qf103KDRy71R0IlSi64o2ruoUP271rPoZsc/MUbvssbBvJyolVz6O54uQUs2sJMZMOFIecMeSs/NwxMi2aeNRAHZ3Xik55nULmgWMMLPO04ZBmEl8evssvUfMTqdDaFbJgBj2OEfqHt2ygWKhWmCNzqIgu3upuBidKAnbPfn9ChPWVjiAukNt6ftz4eA3ze0CyeSLTiezELX6I/eyiNx3iRhyc9e7cz1WtLWr6rv7anztQ7oej7WjBBwP0f2XJmngKtG6bZTx/JghDx2qTx4ZKSHkQPkaTFzU5/57bXPTjHA6wEnyzIPHvr7S379TZjl4xnuNyJcr0sLG3nFr66i1CerDvQ== nico@desktop"
  ];
  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}
