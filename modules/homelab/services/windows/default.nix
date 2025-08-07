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
    homelab.services.windows = {
      enable = lib.mkEnableOption "enables homeassistant";

      version = lib.mkOption {
        type = lib.types.string;
        default = "11";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "win.${config.homelab.baseDomain}";
      };

      configDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.homelab.configDir}/windows";
      };
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

    virtualisation.oci-containers.containers."windows" = {
      image = "dockurr/windows-arm";
      autoStart = true;
      devices = [
        "/dev/kvm:/dev/kvm"
        "/dev/net/tun:/dev/net/tun"
      ];
      capabilities = {
        NET_ADMIN = true;
      };
      ports = [
        "8006:8006"
        "3389:3389/tcp"
        "3389:3389/udp"
      ];
      volumes = [
        "${cfg.configDir}:/storage"
      ];
      environment = {
        VERSION = cfg.version;
      };
    };
  };
}
