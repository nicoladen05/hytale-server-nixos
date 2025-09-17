{ lib, ... }:
{
    disko.devices = {
        disk.disk1 = {
            device = lib.mkDefault "/dev/sda";
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    boot = {
                        size = "512M";
                        type = "EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                        };
                    };
                    root = {
                        size = "100%";
                        content = {
                            type = "btrfs";
                            extraArgs = [ "-f" ]; # Override existing btrfs partitions
                            subvolumes = {
                                root = {
                                    mountpoint = "/";
                                    mountOptions = [ "noatime" "ssd" ];
                                };
                                nix = {
                                    mountpoint = "/nix";
                                    mountOptions = [ "compress=zstd" "noatime" "ssd" ];
                                };
                                data = {
                                    mountpoint = "/data";
                                    mountOptions = [ "compress=zstd" "ssd" ];
                                };
                                services = {
                                    mountpoint = "/opt/services";
                                    mountOptions = [ "compress=zstd" "ssd" ]
                                }
                            };
                        };
                    };
                };
            };
        };
    };
}