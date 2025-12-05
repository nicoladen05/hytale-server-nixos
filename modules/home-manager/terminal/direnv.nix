{
  lib,
  config,
  ...
}:

{
  options.home-manager.direnv.enable = lib.mkEnableOption "enable direnv and nix-direnv";

  config = lib.mkIf config.home-manager.direnv.enable {
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
