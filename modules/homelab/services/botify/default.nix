{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.botify;

  python = pkgs.python313.override {
    packageOverrides = self: super: {
      aiohttp = super.aiohttp.overridePythonAttrs (old: {
        dependencies = builtins.filter (x: x.pname != "aiodns") old.dependencies;
        doCheck = false;
      });
    };
  };

  pythonEnvironment = python.withPackages (
    p: with p; [
      discordpy
      python-dotenv
      mcstatus
      requests
      rich
      yt-dlp
    ]
  );

  botify = pkgs.fetchFromGitHub {
    owner = "nicoladen05";
    repo = "botify";
    rev = "d103c321cd51aa491edf0b4dc59542a631887839";
    hash = "sha256-a7DhkyqkmDVscsmuf2Av5n/dToB92y6aXJjDauC4w9A=";
  };
in
{
  options.homelab.services.botify = {
    enable = lib.mkEnableOption "Enable Botify Bot";
    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = "A file containing the bots token, prefixed with BOT_TOKEN=";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.botify = {
      description = "Botify Discord Bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        WorkingDirectory = "${botify}";
        Environment = "PYTHONPATH=${botify},PATH=${pkgs.ffmpeg}/bin:/run/current-system/sw/bin:/bin:/usr/bin";
        ExecStart = "${pythonEnvironment}/bin/python -m src.bot";
        Restart = "always";
        EnvironmentFile = cfg.tokenFile;
        User = "${config.system.userName}";
        Group = "users";
      };
    };
  };
}
