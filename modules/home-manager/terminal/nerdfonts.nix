{ lib, pkgs, config, ... }:

{
  options = {
    home-manager.nerd-fonts.enable = lib.mkEnableOption "enable nerd-fonts";
  };

  config = lib.mkIf config.home-manager.nerd-fonts.enable {
    fonts.fontconfig.enable = true;

    home.packages =  with pkgs; [
      nerd-fonts.iosevka
    ];
  };
}
