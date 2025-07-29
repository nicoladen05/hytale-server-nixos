{ lib, config, ... }:
{
  config = lib.mkIf config.nvf.enable {
    programs.nvf.settings.vim = {
      binds.whichKey = {
        enable = true;
        setupOpts = {
          preset = "classic";
          delay = 500;
          win.border = "single";
          padding = [
            2
            2
          ];
        };
      };
    };
  };
}
