{ pkgs, config, lib, secrets, ... }:

{
  options = {
    apps.espanso.enable = lib.mkEnableOption "enable espanso";
  };

  config = lib.mkIf config.apps.espanso.enable {
    services.espanso = {
      enable = true;

      matches = {
        base = {
          matches = [
            {
              trigger = ".test";
              replace = "hallo";
            }
            {
              trigger = ".mail";
              replace = secrets.accounts.gmail.address;
            }
          ];
        };
      };
    };
  };
}
