{ lib, config, ... }:

{
  options = {
    home-manager.alacritty.enable = lib.mkEnableOption "Enable the alacritty terminal";
  };

  config = lib.mkIf config.home-manager.alacritty.enable {
    programs.alacritty = {
      enable = true;

      settings = {

        font.offset.y = 4;
        font.glyph_offset.y = 2;

        window = {
          padding.x = 15;
          padding.y = 15;
        };

        cursor = {
          style.shape = "Block";
        };
      };
    };
  };
}
