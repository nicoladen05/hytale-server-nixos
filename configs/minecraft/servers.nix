{ pkgs, ... }:

let
  whitelist = import ./whitelist.nix;
  mods = import ./mods.nix { inherit pkgs; };
in
{
  arthem_survival = {
    host = "vps";
    domain = "mc2.nicoladen.dev";
    port = 25566;
    type = "fabric";
    version = "1.21.11";
    ram = "4G";
    whitelist = whitelist.luca;
    properties = {
      difficulty = "hard";
    };
    mods = {
      enable = true;
      mods = mods.default // mods.cheaty;
    };
  };

  survival_latest = {
    host = "vps";
    domain = "mc.nicoladen.dev";
    type = "fabric";
    version = "1.21.11";
    ram = "4G";
    whitelist = whitelist.default;
    mods = {
      enable = true;
      mods = mods.default // mods.building;
    };
  };
}
