{
  arthem_survival = {
    host = "vps";
    domain = "mc2.nicoladen.dev";
    port = 25566;
    type = "fabric";
    version = "1.21.11";
    ram = "4G";
    packwiz = {
      enable = true;
      url = "https://raw.githubusercontent.com/nicoladen05/minecraft-mods/refs/heads/master/pack.toml";
      packHash = "sha256-0BPB0zxFQyM1SqAPD6O/uBKyAceBBzFdH0+p/1fVsvQ=";
    };
  };

  survival_latest = {
    host = "vps";
    domain = "mc.nicoladen.dev";
    type = "fabric";
    version = "1.21.11";
    ram = "4G";
    packwiz = {
      enable = true;
      url = "https://raw.githubusercontent.com/nicoladen05/minecraft-mods/refs/heads/master/pack.toml";
      packHash = "sha256-0BPB0zxFQyM1SqAPD6O/uBKyAceBBzFdH0+p/1fVsvQ=";
    };
  };
}
