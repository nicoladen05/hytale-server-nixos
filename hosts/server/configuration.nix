{
    config,
    pkgs,
    inputs,
    ...
}:

let
    userName = "nico";
    hostName = "server";
in
{
    imports = [
        # ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../modules/homelab
    ];

    # System configuration
    system = {
        enable = true;
        sops.enable = true;

        # User account
        inherit userName;
        inherit hostName;
        password = {
            enable = true;
            hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
        };
        passwordlessRebuild = true;
    };

    system.stateVersion = "25.05";
}
