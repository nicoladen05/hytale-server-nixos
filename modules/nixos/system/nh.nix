{ lib, config, ... }:

{
  options = {
    nh.enable = lib.mkEnableOption "enables nh";
  };

  config = {
    programs.nh = lib.mkIf config.nh.enable {
      enable = true;
      flake = "/home/nico/.config/nixos/";
    };
  };
}
