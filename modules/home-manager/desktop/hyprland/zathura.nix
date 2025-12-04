{ lib, config, ... }:

{
  options = {
    home-manager.zathura.enable = lib.mkEnableOption "enable zathura";
  };

  config = lib.mkIf config.home-manager.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        sandbox = "none";
        statusbar-h-padding = 0;
        statusbar-v-padding = 0;
        page-padding = 1;
        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        scroll-page-aware = "true";
        scroll-full-overlap = 0.01;
        scroll-step = 100;
      };
      mappings = {
        "n" = "scroll down";
        "e" = "scroll up";
        "i" = "scroll right";
      };
    };
  };
}
