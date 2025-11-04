{
  modulesPath,
  config,
  inputs,
  pkgs,
  ...
}:

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
    sops.enable = true;

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
    external = true;

    configDir = "/home/nico/services";
    baseDomain = "nicoladen.dev";

    services = {
      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
        domains = [
          "vps.nicoladen.dev"
          "n8n.nicoladen.dev"
          "panel.nicoladen.dev"
        ];
      };

      n8n.enable = true;

      pyrodactyl.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.nico.extraGroups = [ "docker" ];

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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDB6jsD23KsTSZn9sa1tjgUKDvIIH3BDEQVuPUdxvf++liDvIVm9AQfcVv3smYftvdLLwkEHrzt+Qm5En31oQSdbljGBTuIGXQcVMUYn+83rVIke5xwC7F3279pSqsvcS1atqLVRuYwOWb07TIlaHojG4oXyzPTjnszU80nKcTJ9EvlNx0VI5UI/C33A0DaCvJbBzM9Hi7Jpqn76Ln0ZQ+CHOhGBBRZwmXLrEN+VdSItPBGBqsILHQAr0LTQbvfR7hs+cmxRsA19mS/h9UJimkoX1HmIljT6ztJsHy8LqAk93yL1VBd/Jm50uvsasVHtlz/tXR6MsCn5w+0SsZhW8zst+z4Euzb0cjEN0UylUJGNw8nlF9ZjnMbAdidT8yfpqmV01CUBxtO7iqIiERUFS/ayqq+tggGGBMWlGimulX75HowhvmAHi/rCtCq02CN5rzzhgAVcsN3ZnbQiPq38kKBFGFwHnp6RfHcNv6bDwABvbiRgbCtglrzfX5LJY1lZcpUxbAJMa1iyR6zm0EUMK0QfNHdVre5kASCzeLVfmDj0NhIqO93YRScM2GtbOND5YSqECVf+XeL5POOL56wNxdVaWQtUUYbosu+74MDZk9KoWyUAG64DRHjMOMVQ66EiwXHHCB5dpwDgkdxXwxDFSfL8wBPs9ZTxZXW9N2Lu20fdw== nico@desktop"
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
