{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_MODELS = /home/nico/data/models;
      OLLAMA_HOST = "0.0.0.0";
    };
  };
}
