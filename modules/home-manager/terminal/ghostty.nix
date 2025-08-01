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
    };
  };
}
