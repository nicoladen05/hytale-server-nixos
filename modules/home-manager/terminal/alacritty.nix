{ lib, config, ... }:

{
  options = {
    terminal.alacritty.enable = lib.mkEnableOption "Enable the alacritty terminal";
  };

  config = lib.mkIf config.terminal.alacritty.enable {
    programs.alacritty = {
      enable = true;

      settings = {

        font.offset.y = 5;

        window = {
          padding.x = 25;
          padding.y = 25;
        };

        cursor = {
          style.shape = "Block";
        };
      };
    };
  };
}
