{
  chill_modded = {
    host = "vps";
    domain = "mc2.nicoladen.dev";
    port = 25566;
    type = "fabric";
    version = "1.21.1";
    ram = "6G";
    packwiz = {
      enable = true;
      url = "https://raw.githubusercontent.com/nicoladen05/minecraft-mods/refs/heads/addon/immersive/pack.toml";
      packHash = "sha256-2HogG+bCESJyazvpkwo2W2tOrnmUfoebBpip6IjBclU=";
    };
  };
  survival_latest = {
    host = "vps";
    domain = "mc.nicoladen.dev";
    type = "fabric";
    version = "1.21.10";
    ram = "4G";
    packwiz = {
      enable = false;
    };
  };
}
