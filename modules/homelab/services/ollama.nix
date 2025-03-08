{ config, lib, ... }:

{
  options = {
    homelab.services.ollama = {
      enable = lib.mkEnableOption "enable ollama";

      useCuda = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
      };

      modelDirectory = lib.mkOption{
        type = lib.types.path;
      };
    };
  };

  config = lib.mkIf config.homelab.services.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration = lib.mkIf config.homelab.services.ollama.useCuda "cuda";
      environmentVariables = {
        OLLAMA_MODELS = config.homelab.services.ollama.modelDirectory;
        OLLAMA_HOST = "0.0.0.0";
      };
    };
  };
}
