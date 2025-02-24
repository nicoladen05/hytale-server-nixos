{ pkgs, lib, config, ... }:

{
  options = {
    vfio = {
      enable = lib.mkEnableOption "Enable vfio passthrough vm";
    };
  };

  config = lib.mkIf config.vfio.enable {
    boot = {
      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ];
    };

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };

    users.groups.libvirtd.members = ["nico"];

    programs.virt-manager.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
