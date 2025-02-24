{ pkgs, lib, config, ... }:

{
  options = {
    nh.enable = lib.mkEnableOption "enables nh";
  };

  config = {
    environment.sessionVariables = {
      FLAKE = "/home/nico/.config/nixos/";
    };

    programs.nh = lib.mkIf config.nh.enable {
      enable = true;
      flake = "/home/nico/.config/nixos/";
    };
  };
}
