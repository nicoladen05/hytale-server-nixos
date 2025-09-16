{ config, lib, ... }:

let
  cfg = config.homelab.services.blocky;
in
{
  options.homelab.services.blocky = {
    enable = lib.mkEnableOption "Enable Blocky";
    settings = {
      port = lib.mkOption {
        type = lib.types.int;
        default = 53;
      };

      blockLists = lib.mkOption {
        type = lib.types.attrsOf lib.types.listOf lib.types.str;
        default = {};
      };

      allowLists = lib.mkOption {
        type = lib.types.attrsOf lib.types.listOf lib.types.str;
        default = {};
      };

      groups = lib.mkOption {
        type = lib.types.attrsOf lib.types.listOf lib.types.str;
        default = {};
      };

      clients = lib.mkOption {
        type = lib.attrsOf lib.types.str;
        default = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      ports.dns = cfg.port;

      # Upstream DNS Config 
      # TODO: Update for unbound
      upstreams.groups.default = [ "1.1.1.1" "1.0.0.1" ];
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };

      # Blocking
      blocking = {
        denylists = cfg.blockLists;
        allowlists = cfg.allowLists;
        clientGroupsBlock = cfg.groups;
      };

      # Client names
      clientLookup.clients = cfg.clients;
    };
  };
}
