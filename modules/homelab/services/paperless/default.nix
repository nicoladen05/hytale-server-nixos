{ lib, config, ... }:

let
  cfg = config.homelab.services.paperless;
in
{
  options.homelab.services.paperless = {
    enable = lib.mkEnableOption "Enable Paperless";
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/data/paperless";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0775 paperless users -"
    ];

    services.paperless = {
      enable = true;
      mediaDir = cfg.dataDir;
      settings = {
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
        ];
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
      };
    };
  };
}
