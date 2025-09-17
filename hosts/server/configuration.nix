{
    config,
    lib,
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

  # Static ip
  networking.interfaces.enp1s0.ipv4.addresses = [
    {
      address = "192.168.2.2";
      prefixLength = 24;
    }
  ];

  # Users
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;
  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}
