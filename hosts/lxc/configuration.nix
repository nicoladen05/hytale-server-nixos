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

  homelab = {
    enable = true;
    configDir = "/opt";
    baseDomain = "lxc.local";
    services = {
      homeassistant = {
        enable = true;
      };
    };
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];

  nix.settings = { 
    sandbox = false; 
    trusted-users = [ "@wheel" ];
  };  

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
