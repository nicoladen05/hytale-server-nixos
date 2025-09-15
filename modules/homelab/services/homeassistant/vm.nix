{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.homelab.vms.haos;
  nixvirt = inputs.nixvirt;

  haosImage = pkgs.fetchurl {
    name = "haos_ova-16.2.qcow2";
    url = "https://github.com/home-assistant/operating-system/releases/download/16.2/haos_ova-16.2.qcow2.xz";
    hash = "sha256-pTkiuGLU3PjZbn4IYNt/B8+u4h9BV3LACyjKrwzhU0w=";
    postFetch = ''
      cp $out src.xz
      ${pkgs.xz}/bin/unxz src.xz --stdout > $out
    '';
  };

  vmDomain = nixvirt.lib.domain.templates.linux {
    name = "homeassistant";
    uuid = "cc7439ed-36af-4696-a6f2-1f0c4474d87e";
    memory = { count = 2; unit = "GiB"; };
    storage_vol = haosImage;
  };
  
  vmDomainXML = nixvirt.lib.domain.writeXML vmDomain;
in
{
  options.homelab.vms.haos = {
    enable = lib.mkEnableOption "Enable the Homeassistant Operating System VM";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirt = {
      enable = true;

      connections."qemu:///session".domains = [
        {
          definition = vmDomainXML;
        }
      ];
    };
  };
}
