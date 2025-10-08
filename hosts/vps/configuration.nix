{ modulesPath, config, inputs, pkgs, ... }:

let
  userName = "nico";
  hostName = "vps";
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/homelab
  ];

  # System config
  system = {
    enable = true;

    inherit userName;
    inherit hostName;

    passwordlessRebuild = true;

    shell = pkgs.zsh;

    tcpPorts = [
      16662
      25565
      25566
      25567
      3000
    ];
  };

  homelab = {
    enable = true;

    configDir = "/home/nico/services";
    baseDomain = "nicoladen.dev";

    services = {
      wireguard = {
        enable = false;
        externalInterface = "eth0";
        ips = [
          "192.168.255.2/32"
          "fd3a:6c4f:1b2e::2/128"
          "2003:e0:17ff:3b42::2/128"
        ];
        privateKeyFile = config.sops.secrets."wireguard/privkey".path;
        peers = {
          phone = {
            publicKey = "HUJGJf2uFa8p8EpwQNS5ZKz06qIQOd1uquA8zGkB1Ag=";
            allowedIPs = ["0.0.0.0/0" "::/128"];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          server = {
            publicKey = config.sops.secrets."wireguard/pubkey".value;
            allowedIPs = ["0.0.0.0/0" "::/128"];
            endpoint = "ddns.nicoladen.dev:51820";
          };
        };
      };
    };
  };

  services.caddy.virtualHosts."obsidiansync.nicoladen.dev".extraConfig = ''
    reverse_proxy 127.0.0.1:5984
  '';

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.nico.extraGroups = [ "docker" ];

  services.cron = {
    enable = true;
    systemCronJobs = [
      "5 3 * * * podman restart minecraft"
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      userName = "${config.system.userName}";
    };
    users = {
      "nico" = import ./home.nix;
    };
  };

  nvf.enable = true;
  programs.nvf.settings.vim.theme = {
    enable = true;
    name = "github";
    style = "dark_dimmed";
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    targets.nvf.enable = false;
  };

  packages = {
    enable = true;
    terminal.enable = true;
  };

  boot.kernelParams = [ "net.ifnames=0" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXGyUgkeoDxvW+FiwBHqPbtwzvyb5GosDgIaE3uBihImtMZTjEHVKWob8nkMqGqu+ga+axck5F1rwvIDcLufnin3N74D2R6xVa4VwC2DNHThzxoyfDvjxTqvaxAoqnQWLd3IyLKxTgnstdXsOwIgTKtqWcL5g5CvSpsHmxVSQVFlUXpuhM8F8jDr573dpCtBrD7fpkC64Q4hMtWUDch1DLleHLv9Jjf1GYe01sPvrRfzKC5pXnHSXiddOgyzDHnU+MK6vqbETGcrB89ENcFZUveJGON1KfwM9x3JCiP5IVz3Pxam72XKy0eRMUda2ZGgT7EP/KpJA+ESlkT58qf103KDRy71R0IlSi64o2ruoUP271rPoZsc/MUbvssbBvJyolVz6O54uQUs2sJMZMOFIecMeSs/NwxMi2aeNRAHZ3Xik55nULmgWMMLPO04ZBmEl8evssvUfMTqdDaFbJgBj2OEfqHt2ygWKhWmCNzqIgu3upuBidKAnbPfn9ChPWVjiAukNt6ftz4eA3ze0CyeSLTiezELX6I/eyiNx3iRhyc9e7cz1WtLWr6rv7anztQ7oej7WjBBwP0f2XJmngKtG6bZTx/JghDx2qTx4ZKSHkQPkaTFzU5/57bXPTjHA6wEnyzIPHvr7S379TZjl4xnuNyJcr0sLG3nFr66i1CerDvQ== nico@desktop"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4UI+xzCxmgUgxZVz9JS1VgYHCUpWEroiAcy8sNpiMdHlS3W74wqpcGtdwQOWbFTTjksB/5OWvhfjblgYMvL45H+SSHS/mwu95UD3tcSP7FAUVUyls2enC6+H8ufLM5onY0nF4pv+t4IosB+ulCjcuNity++ClkGCkGu/D0WSG212I93DY+KgqVhaE4pHmO6Lfo6l8H1DvKEHodh2Nd9VNVd4V3WeczELGFvMnQmcZY86L5xnjQSqbJPX6Cil8oawpbHOSjrNy9Cmn6eC4CJ2kTc5aWA05p09WcJzWSov9lyalYkEbog9Cz1T6ceDesHiyCxh3eHhUrDuS/Gan615To3YUREUsPklwNkifyxHiVEeR7kae10n31X1I8S/q+Wh1XRYjtjDUW1oY0CtX+oThfwikTKMyRxaJJN29lOiaWYZHNVL++w66qGiq2E3jirCg2glu9R1IAEsu7Zqwb8zG5AgrhXwcNVlH0Sp1+KeqF1C+iDrYMj6l7x8qpvamWJlzE0lQwEkLZKdwHSzHPtAyl03i357kZIdeOFSSesJ9SMdBV1K1cUDqCVCma2+s83wuUOA1dFohKnxGnWPa7qKAJ9dSwVYRVYJDZFfrYO8gFJXNKBNcOk9o5SM9qaI7b2SpxYkPn7h/grHty0gVd43Punrv0bx2EjV9xGz871xGIQ== nico@work"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCFTv0zmG+noCzsfKPg0NMTELnweYw4c1gRJ1mGNLwo9R03fHbYJw7zsZ381XWcAWTEa9gysA4LcVhSj9zON0EcD81sbpSAGBSwt61g1nx2X+v3jScRThPAcgrGxdozgcF7tlYDZqy2z5Tm94j/6AswMN/YL2iUxJPiHZcIaZlzVD4Nv8fVTo8SE1poLJBA9xMovYBvVLruyr6yGm2LPu5b3zN3wrQUxrIIxxmzCEtfCsXL3A6gz5OBIoJ5y5/4SE9WveNGdVEcWIcbz4blcTEL4HrZNxrGvBlo+rHxHgd6CbWL/FK92h/rvJKxBU3qMMswr/P3i02Ycl6lS+gwnS8selL0ZAzO47Xz90EAH/5JqSyv8PY/1N6s2LoNCFDOHyX+Sx0SxN7kyoqlH3bbgR2CPpLxixFPnwG8zXxBH0ZywBh4h5EykzuDyb9I5iUYQMPSBRWoKInCjXxPL4fYulckwtB+Rj/neDZEWeUFLG1N3Y+IdInE4GHJYL1dyEz+z9cImQgbcehdIe8WkNppHF3ixksJouWI3qBwYFWVxKAk/s3lP2N2ld8YY2zq70qINfMmMKw4pVIvcCvesGd1m1mEz6kL5TGgPZMjzJ/trAoi/jBbNUoz+eiSstYhL5UHTCwrL272cpBPybAtSSyqyw2lJptePfZCtvXhRfdYoRozQ== nico@server"
  ];

  nix.settings.trusted-users = [ "${config.system.userName}" ];

  system.stateVersion = "25.05";

  # Static ip
  networking = {
    defaultGateway = "10.0.0.1";
    nameservers = [
      "8.8.8.8"
    ];
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.68"; # This is the ip address configured in oracle cloud
          prefixLength = 24;
        }
      ];
      # For IPv6
      useDHCP = true;
    };
  };
}
