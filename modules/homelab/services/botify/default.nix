{ lib, config, pkgs, ... }:

let
  cfg = config.homelab.services.botify;

  # botifyPkgs = import <nixpkgs> {
  #   overlays = [ (import ../../../../overlays/default.nix) ];
  # };

  pycordPkg = pkgs.python313Packages.pycord.override { voiceSupport = true; };

  pythonEnvironment = pkgs.python313.withPackages(p: with p; [
    pycordPkg
    python-dotenv
    pexpect
    aiohttp
    mcstatus
    # We need to replace discord.py with pycord in the wavelink
    # build inputs, otherwise we'll have two derivations providing
    # the discord namespace
    (wavelink.overridePythonAttrs (old: {
      dependencies =
        (builtins.filter (pkg: pkg.pname != "discord.py")
          (old.propagatedBuildInputs or []))
        ++ [ pycordPkg ];
    }))
  ]);

  botify = pkgs.fetchFromGitHub {
    owner = "nicoladen05";
    repo = "botify";
    rev = "cdb880d92a497608e68810fa3dc9785789b315df";
    sha256 = "sha256-EjP9Do1ZUTWZELy7ah7PaPnoS4LNeH1p+k4LcS5O5O0=";
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
        ExecStart = "${pythonEnvironment}/bin/python ${botify}/src/bot.py";
        Restart = "always";
        EnvironmentFile = cfg.tokenFile;
      };
    };
  };
}
