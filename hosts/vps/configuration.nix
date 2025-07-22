{ modulesPath, config, lib, input, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
	../../modules/nixos/system
  ];

  system = {
	enable = true;
  
  	userName = "nico";
  	hostName = "vps";
  };

  boot.kernelParams = [ "net.ifnames=0" ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC48NdWVvqBb7eEfDWSrTyc8aGA496kJTjCYImIIpcbv"
  ];

  users.users.nico.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC48NdWVvqBb7eEfDWSrTyc8aGA496kJTjCYImIIpcbv"
  ];

  system.stateVersion = "25.05";

  networking = {
    defaultGateway = "10.0.0.1";
    nameservers = [
        "8.8.8.8"
    ];
    interfaces.eth0 = {
        ipv4.addresses = [
        {
            # Use IP address configured in the Oracle Cloud web interface
            address = "10.0.0.68";
            prefixLength = 24;
        }
        ];
        # Only "required" for IPv6, can be false if only IPv4 is needed
        useDHCP = true;
    };
    # Note: you also need to configure open ports in the Oracle Cloud web interface
    # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
    firewall = {
        # (both optional)
        allowedTCPPorts = [ 22 ];
        logRefusedConnections = false;
        rejectPackets = true;
    };
  };
}
