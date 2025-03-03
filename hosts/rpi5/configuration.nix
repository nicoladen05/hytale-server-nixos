{ pkgs, lib, inputs, config, ... }:

{
  imports = [
    ../../modules/nixos/system
    ../../modules/homelab
  ];

  system = {
    enable = true;

    hostName = "rpi5";
    systemdBoot = false;

    tcpPorts = [ 22 ];
  };

  homelab = {
    enable = true;
    configDir = "/home/nico/";
    baseDomain = "nerduniverse.duckdns.org";

    services.homeassistant.enable = true;
  };

  users.users.nico.initialPassword = "password"; # For ssh login on first boot

  raspberry-pi-nix = {
    board = "bcm2712";
    uboot.enable = false;
    libcamera-overlay.enable = false;
    serial-console.enable = false;
  };

  services.openssh.enable = true;
}
