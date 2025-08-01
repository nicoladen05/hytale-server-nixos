{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    home-manager.ghostty.enable = lib.mkEnableOption "enable ghostty terminal";
  };

  config = lib.mkIf config.home-manager.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-family = "Iosevka NFM";
        font-size = 14;
        cursor-style-blink = false;
        background-opacity = 0.95;
        window-padding-x = 10;
        window-padding-y = 10;
        window-padding-balance = true;
        adjust-cell-height = "50%";
        confim-close-surface = false;
      };
    };
  };
}
