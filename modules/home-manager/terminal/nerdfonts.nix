{ lib, pkgs, config, ... }:

{
  options = {
    font.nerd-fonts.enable = lib.mkEnableOption "enable nerd-fonts";
  };

  config = lib.mkIf config.font.nerd-fonts.enable {
    fonts.fontconfig.enable = true;

    home.packages =  with pkgs; [
      nerd-fonts.iosevka
    ];
  };
}
