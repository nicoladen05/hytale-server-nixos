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
      };

      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
        domains = [
          "*.nicoladen.dev"
          "ddns.nicoladen.dev"
          "mc.nicoladen.dev"
        ];
      };

      botify = {
        enable = true;
        tokenFile = config.sops.secrets."services/botify/token".path;
      };

      immich = {
        enable = true;
        hardwareAcceleration = true;
        mediaLocation = "/data/immich";
      };

      pihole.enable = true;

      homeassistant.enable = true;

      vaultwarden.enable = true;

      ocis.enable = true;

      minecraft-server = {
        enable = true;
        servers = {
          chill_modded = {
            type = "fabric";
            version = "1.21.1";
            ram = "6G";
            packwiz = {
              enable = true;
              url = "https://raw.githubusercontent.com/nicoladen05/minecraft-mods/refs/heads/addon/immersive/pack.toml";
              packHash = "sha256-0snr5y8WwlDn7qRU5jw1yM5YOVIY93YYIihlvtC2Jx0=";
            };
          };
        };
      };

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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDB6jsD23KsTSZn9sa1tjgUKDvIIH3BDEQVuPUdxvf++liDvIVm9AQfcVv3smYftvdLLwkEHrzt+Qm5En31oQSdbljGBTuIGXQcVMUYn+83rVIke5xwC7F3279pSqsvcS1atqLVRuYwOWb07TIlaHojG4oXyzPTjnszU80nKcTJ9EvlNx0VI5UI/C33A0DaCvJbBzM9Hi7Jpqn76Ln0ZQ+CHOhGBBRZwmXLrEN+VdSItPBGBqsILHQAr0LTQbvfR7hs+cmxRsA19mS/h9UJimkoX1HmIljT6ztJsHy8LqAk93yL1VBd/Jm50uvsasVHtlz/tXR6MsCn5w+0SsZhW8zst+z4Euzb0cjEN0UylUJGNw8nlF9ZjnMbAdidT8yfpqmV01CUBxtO7iqIiERUFS/ayqq+tggGGBMWlGimulX75HowhvmAHi/rCtCq02CN5rzzhgAVcsN3ZnbQiPq38kKBFGFwHnp6RfHcNv6bDwABvbiRgbCtglrzfX5LJY1lZcpUxbAJMa1iyR6zm0EUMK0QfNHdVre5kASCzeLVfmDj0NhIqO93YRScM2GtbOND5YSqECVf+XeL5POOL56wNxdVaWQtUUYbosu+74MDZk9KoWyUAG64DRHjMOMVQ66EiwXHHCB5dpwDgkdxXwxDFSfL8wBPs9ZTxZXW9N2Lu20fdw== nico@DESKTOP-EMEHM3S "
  ];
  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}
