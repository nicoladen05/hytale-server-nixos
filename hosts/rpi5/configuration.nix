{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  imports = [
    ../../modules/nixos/system
    ../../modules/homelab
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
  ];

  nix.settings.trusted-users = [
    "root"
    "nico"
  ];

  system = {
    enable = true;

    hostName = "rpi5";
    boot.systemdBoot = false;

    tcpPorts = [ 22 ];
  };

  # homelab = {
  #   enable = true;
  #   configDir = "/home/nico/";
  #   baseDomain = "nerduniverse.duckdns.org";
  #
  #   services.homeassistant.enable = true;
  # };

  users.users.nico = {
    initialPassword = "password"; # For ssh login on first boot
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1iVBIj664w8aunoutoTLhc/4SR9kMPhBO1WrfgPccGqfDHujHRDueJGc7e8tAwCf5gOtOT93W3mLtnva9Z/De23igw2KG1yVmnf7sgR/KDYjJgcJcU3Dp9Cea9NlRoPlwyNgFwxbvs3eiolL0VvZ3eNPpfXyCUg2xU7mbbVrm1Fc9kn0jWl910qcINh7ldhyVXHSUTXW+a8ARunoxd/urQ7vanoBagFaT9VMzcT2rTFFONOimGJ/BhL4mL8ZGV3UB/vJeQVBuC0561fCp5bn3tBnA1UUd2cpiqds8T9iYBZRkoAdgkjPQfCcsGxSb64TyeyVCwiVz4B9eE5gkhUFjBDeEKEPOokVtbW6Vr8wKiP0eoxkGlg5FIySOoLbaElxVNAlsaIje4qApnq09ObPX4vU+nCXgS4N7of3ch5UqHzcw9+Dhivoybpboxb2x5Usiy1OzpKPqucFkVWlBlfJbbfOKo5M9+h3hJ3JW1c1fsYLcF8oNeDkFb11FFJnAwD8= nico"
    ];
  };

  services.openssh.enable = true;
}
