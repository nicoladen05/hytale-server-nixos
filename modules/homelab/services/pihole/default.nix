{ lib, config, ... }:

let
  cfg = config.homelab.services.pihole;
in
{
  options.homelab.services.pihole = {
    enable = lib.mkEnableOption "Enable Pihole";
    blockLists = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {
        ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
      };
      description = "List of blocklists to use in Pihole.";
    };
    allowLists = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      description = "List of allowlists to use in Pihole.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pihole-ftl = {
      enable = true;
      openFirewallDNS = true;
      openFirewallWebserver = true;

      lists =
        lib.flatten (
          lib.mapAttrsToList (
            name: list:
            builtins.map (url: {
              enabled = true;
              description = "${name} blocklist";
              type = "block";
              url = url;
            }) list
          ) cfg.blockLists
        )
        ++ lib.flatten (
          lib.mapAttrsToList (
            name: list:
            builtins.map (url: {
              enabled = true;
              description = "${name} allowlist";
              type = "allow";
              url = url;
            }) list
          ) cfg.allowLists
        );
    };

    services.pihole-web = {
      enable = true;
      ports = [ "8080s" ];
    };
  };
}
