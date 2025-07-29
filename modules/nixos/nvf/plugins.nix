{ lib, config, ... }:
{
  options = {
    nvf.enable = lib.mkEnableOption "enable nvf";
  };

  config = lib.mkIf config.nvf.enable {
    binds.whichKey = {
      enable = true;
      setupOpts = {
        preset = "classic";
      };
    };

  };
}
