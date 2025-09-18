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
        type = lib.types.attrs;
        default = {};
      };

      allowLists = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };

      blockGroups = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };

      clients = lib.mkOption {
        type = lib.types.attrs;
        default = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        ports.dns = cfg.settings.port;

        # Upstream DNS Config 
        # TODO: Update for unbound
        upstreams.groups.default = [ "1.1.1.1" "1.0.0.1" ];
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "1.1.1.1" "1.0.0.1" ];
        };

        # Blocking
        blocking = {
          denylists = cfg.settings.blockLists;
          allowlists = cfg.settings.allowLists;
          clientGroupsBlock = cfg.settings.blockGroups;
        };
        
        # Cache
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };

        # Client names
        clientLookup.clients = cfg.settings.clients;
      };
    };
  };
}
