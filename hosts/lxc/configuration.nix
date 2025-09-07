{ modulesPath, pkgs, lib, ... }:

let
  userName = "nico";
  hostName = "lxc";
in

{
  imports = [ 
    (modulesPath + "/virtualisation/proxmox-lxc.nix") 
    ../../modules/nixos
    ../../modules/homelab
  ];

  system = {
    enable = true;
    boot.systemdBoot = false;

    inherit userName;
    inherit hostName;
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };


  nix.settings = { sandbox = false; };  

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  security.pam.services.sshd.allowNullPassword = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
        PermitEmptyPasswords = "yes";
    };
  };

  system.stateVersion = "25.05";
}
