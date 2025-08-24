{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.windows;
in
{
  options = {
    homelab.services.filestash = {
      enable = lib.mkEnableOption "enables filestash";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

    virtualisation.oci-containers.containers."filestash" = {
      image = "machines/filestash:latest";
      autoStart = true;
      environment = {
        APPLICATION_URL = "stash.nicoladen.dev";
        CANARY = true;
        OFFICE_URL = "http://wopi_server:9980";
        OFFICE_FILESTASH_URL = "http://app:8334";
        OFFICE_REWRITE_URL = "http://127.0.0.1:9980";
      };
      volumes = [
        "filestash:/app/data/state"
      ];
      ports = [
        "8334:8334"
      ];
    };
  };
}
