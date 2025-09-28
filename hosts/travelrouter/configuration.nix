{ nixos-raspberrypi, config, ... }:

{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
    raspberry-pi-5.bluetooth
    sd-image
  ];

  networking.hostName = "travelrouter";

  users.users."nico" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5BIr0SEPaA6JLVriI5tpbiOORp6qE+D25uqEEY+BvtAwUxpn8PWo33il8bw1aD8HUptiToPBFHcx3H7TL2o1O+b1kADvfOsCSfZM2bATp1fZ6zkzeSpApG5Ahu5CgpZnL+PMwIyeY4o2G/iRLGyF9Q3+edyhBOX+jbbdW9Xht35nne87/3rUCoiXXXLK6vwY5FIFxNzxU/40JWVhdlbXSvXVVPpx+eNnnJcOdUWGcDIk6ozLihZW21uwmwnfHN99ndibAMF0GHB+lPBIe9GGJHF/KQHJI4glz7Dta0pI30BHR2ZXaEVXI265NTVdY0tKqsoT5bwOeJ+14tivkpnXfbxpBBCx3n/Cts/Rs3PCBCCKzhxvNdx5S08dF/5xQXMzoYRABbMPVxqDvjnNY8chhDlLkfDv9vEE44llzuBwSby83n0Ikn9NVn3Q5vbbZYYpS96agYdbiL0ia65TfMyIKVRfx+YLG6YtDYRuf1qvxsZsWrfi2BvXUvYx/+PaelW+lp0O5/3BFZSId4Bk25Z73lwEaucWw/Z2zim0C425o++Tu0u3tVkvglFgs2kbVJUpXn9gtxzihU0bW7sF8LuuUkg0LL/mcpR3q445I1W3AVcayuWCd3GCWRN/Aw22d3egVbVv2Ku7FrEUelBXupfo4NO9UqUlcNj/04WQb34jZKQ== nico@desktop"
  ];

  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
