{
  config,
  lib,
  ...
}: {
  options = {
    filemanager.yazi.enable = lib.mkEnableOption "enable yazi";
  };

  config = lib.mkIf config.filemanager.yazi.enable {
    programs.yazi = {
      enable = true;
      keymap = {
        manager.prepend_keymap = [
          { on = ["n"]; run = "arrow 1"; desc = "Move cursor down"; }
          { on = ["N"]; run = "arrow 5"; desc = "Move cursor down"; }
          { on = ["j"]; run = "find_arrow"; desc = "Move cursor up"; }
          { on = ["e"]; run = "arrow -1"; desc = "Move cursor up 5 lines"; }
          { on = ["E"]; run = "arrow -1"; desc = "Move cursor up 5 lines"; }
          { on = ["k"]; run = "open"; desc = "Move cursor down 5 lines"; }
          { on = ["K"]; run = "open --interactive"; desc = "Move cursor down 5 lines"; }
          { on = ["i"]; run = "enter"; desc = "Open file or enter directory"; }
          { on = ["l"]; run = "leave"; desc = "Go back to the parent directory"; }
        ];
      };

      settings = {
        plugin = {
          prepend_previewers = [
            { mime = "application/pdf"; run = "pdf"; }
          ];
        };
      };
    };
  };
}
