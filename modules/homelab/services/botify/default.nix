{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.botify;

  # botifyPkgs = import <nixpkgs> {
  #   overlays = [ (import ../../../../overlays/default.nix) ];
  # };

  pycordPkg = pkgs.python313Packages.pycord.override { voiceSupport = true; };

  pythonEnvironment = pkgs.python313.withPackages (
    p: with p; [
      pycordPkg
      python-dotenv
      pexpect
      (aiohttp.overridePythonAttrs (old: {
        dependencies = builtins.filter (x: x.pname != "aiodns") old.dependencies;
        doCheck = false;
      }))
      mcstatus
      requests
      # We need to replace discord.py with pycord in the wavelink
      # build inputs, otherwise we'll have two derivations providing
      # the discord namespace
      (wavelink.overridePythonAttrs (old: {
        dependencies =
          (builtins.filter (pkg: pkg.pname != "discord.py") (old.propagatedBuildInputs or [ ]))
          ++ [ pycordPkg ];
      }))
    ]
  );

  botify = pkgs.fetchFromGitHub {
    owner = "nicoladen05";
    repo = "botify";
    rev = "6332a9754927fef988ae14ba1b07279eb7de5049";
    sha256 = "sha256-8fNZImDdZ+DmoJvmhDYtIowu6x79bGgtGhUVNY4hl8A=";
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
        # Required for minecraft server commands
        Environment = "PATH=${pkgs.openssh}/bin:/run/current-system/sw/bin:/bin:/usr/bin";
        User = "${config.system.userName}";
        Group = "users";
      };
    };
  };
}
