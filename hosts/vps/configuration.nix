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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC48NdWVvqBb7eEfDWSrTyc8aGA496kJTjCYImIIpcbv"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEztxKjajt/4t2hhu80eEiLps75mewRnILzlBs01RFYk"
  ];

  nix.settings.trusted-users = [ "root" "${userName}" ];

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
