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
        enable = false;
        repositoryFile = config.sops.secrets."restic/repository".path;
        passwordFile = config.sops.secrets."restic/password".path;
        environmentFile = config.sops.secrets."restic/environment".path;
      };

      ddns = {
        enable = false;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
      };

      botify = {
        enable = false;
        tokenFile = config.sops.secrets."services/botify/token".path;
      };

      immich = {
        enable = true;
        hardwareAcceleration = true;
        mediaLocation = "/data/immich";
      };

      pihole = {
        enable = true;
        blockLists = network.blocklists;
      };

      homeassistant.enable = true;

      vaultwarden.enable = true;

      ocis.enable = false;

      n8n.enable = false;

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
            allowedIPs = [
              "0.0.0.0/0"
              "::/128"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
        };
      };
    };
  };

  # Static ip
  services.resolved.enable = false;
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
    resolvconf.enable = true;
  };

  # Users
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCX3Ob1TSQcFsohvfmoDf4vfidPIyFgZw0s10yX6mSXyosb0xZad0WqBIt4V1Djdw2OhCPh5lQ7AaNCXElnxeEppbR+vRoZQbX3d7i1HN50kxXoajxZcBmtsuMeCaorzO4Rdvvp2Oz+kAN/lww0frqaF0dcZEMtvngnj7puoTOFhVZvCy9HjO7XYWltRi+/xMr0yXn6+LVJ8P6gD5I9UfqnKGF6lgNPIHCNnFZfL0qKQw4CuZDOEsq9046Yp3wO+L2p6WopJqjjrAxtiPht85p8LwDj4FaRFBRz9yVBeQBUlMNaiSM/VRN2vqL+W0nMPi9CEpiHDaKmEJamxqkmOrVs1fCkJAQDjH8H4ajhOaRCxWysHe1GNaIjIlguawnOGgtBYus8fkt+20MD+9QiGhP9frYLwdNO0p+KFjObyCePFX081MPoaAPYF8AokomRVW9NwTeG19Cv6bym78Dc/UNku5Xqkr3Mmj9vQ8LNLPz1nR3WVr6yahnbTWAV1nHG8+4+X4snyX/uHRyd14Gdu0LKSIFKTigRIja9123PPw9+huGrziTjiAlGdQZGN4m9E24detEuNzIT9J2iztyML8Ml8PeR4oyHBSFa8C7/dqT80Gq9ZZBcSChqDFvhvvEctlsbrYWA+zMvjBaE/w+GQDDurlxE7WZGIQYqM1ckKD3Q7Q== nico@desktop"
  ];
  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}
