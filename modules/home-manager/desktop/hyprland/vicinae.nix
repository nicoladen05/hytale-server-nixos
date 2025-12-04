{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  options = {
    home-manager.vicinae.enable = lib.mkEnableOption "enables vicinae";
  };

  config = lib.mkIf config.home-manager.vicinae.enable {
    nixpkgs.overlays = [ inputs.vicinae.overlays.default ];

    services.vicinae = {
      enable = true;
      settings = {
        closeOnFocusLoss = true;
        faviconService = "twenty";
        font = {
          normal = "Maple Mono NF CN";
          size = 10;
        };
      };
    };
  };
}
