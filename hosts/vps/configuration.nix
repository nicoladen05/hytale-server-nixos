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

    shell = pkgs.zsh;

    tcpPorts = [
      16662
      25565
      25566
      3000
    ];
  };

  homelab = {
    enable = true;

    configDir = "/home/nico/services";
    baseDomain = "nicoladen.dev";
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

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
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
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  services.fail2ban.enable = true;

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5BIr0SEPaA6JLVriI5tpbiOORp6qE+D25uqEEY+BvtAwUxpn8PWo33il8bw1aD8HUptiToPBFHcx3H7TL2o1O+b1kADvfOsCSfZM2bATp1fZ6zkzeSpApG5Ahu5CgpZnL+PMwIyeY4o2G/iRLGyF9Q3+edyhBOX+jbbdW9Xht35nne87/3rUCoiXXXLK6vwY5FIFxNzxU/40JWVhdlbXSvXVVPpx+eNnnJcOdUWGcDIk6ozLihZW21uwmwnfHN99ndibAMF0GHB+lPBIe9GGJHF/KQHJI4glz7Dta0pI30BHR2ZXaEVXI265NTVdY0tKqsoT5bwOeJ+14tivkpnXfbxpBBCx3n/Cts/Rs3PCBCCKzhxvNdx5S08dF/5xQXMzoYRABbMPVxqDvjnNY8chhDlLkfDv9vEE44llzuBwSby83n0Ikn9NVn3Q5vbbZYYpS96agYdbiL0ia65TfMyIKVRfx+YLG6YtDYRuf1qvxsZsWrfi2BvXUvYx/+PaelW+lp0O5/3BFZSId4Bk25Z73lwEaucWw/Z2zim0C425o++Tu0u3tVkvglFgs2kbVJUpXn9gtxzihU0bW7sF8LuuUkg0LL/mcpR3q445I1W3AVcayuWCd3GCWRN/Aw22d3egVbVv2Ku7FrEUelBXupfo4NO9UqUlcNj/04WQb34jZKQ== nico@desktop"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4UI+xzCxmgUgxZVz9JS1VgYHCUpWEroiAcy8sNpiMdHlS3W74wqpcGtdwQOWbFTTjksB/5OWvhfjblgYMvL45H+SSHS/mwu95UD3tcSP7FAUVUyls2enC6+H8ufLM5onY0nF4pv+t4IosB+ulCjcuNity++ClkGCkGu/D0WSG212I93DY+KgqVhaE4pHmO6Lfo6l8H1DvKEHodh2Nd9VNVd4V3WeczELGFvMnQmcZY86L5xnjQSqbJPX6Cil8oawpbHOSjrNy9Cmn6eC4CJ2kTc5aWA05p09WcJzWSov9lyalYkEbog9Cz1T6ceDesHiyCxh3eHhUrDuS/Gan615To3YUREUsPklwNkifyxHiVEeR7kae10n31X1I8S/q+Wh1XRYjtjDUW1oY0CtX+oThfwikTKMyRxaJJN29lOiaWYZHNVL++w66qGiq2E3jirCg2glu9R1IAEsu7Zqwb8zG5AgrhXwcNVlH0Sp1+KeqF1C+iDrYMj6l7x8qpvamWJlzE0lQwEkLZKdwHSzHPtAyl03i357kZIdeOFSSesJ9SMdBV1K1cUDqCVCma2+s83wuUOA1dFohKnxGnWPa7qKAJ9dSwVYRVYJDZFfrYO8gFJXNKBNcOk9o5SM9qaI7b2SpxYkPn7h/grHty0gVd43Punrv0bx2EjV9xGz871xGIQ== nico@work"
  ];

  nix.settings.trusted-users = [ "root" "nico" ];

  system.stateVersion = "25.05";

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
