{ userName, inputs, lib, secrets, config, ... }:

{
  imports =
    [
      ./desktop
      ./terminal
      ./firefox.nix
    ];

    options = {
      home-manager.enable = lib.mkEnableOption "Enable home-manager";

      git.userName = lib.mkOption {
        type = lib.types.str;
        default = "nicoladen05";
        description = "The name to use for git commits";
      };
      git.userEmail = lib.mkOption {
        type = lib.types.str;
        default = "${secrets.accounts.gmail.address}";
        description = "The email to use for git commits";
      };
    };

    config = lib.mkIf config.home-manager.enable {
      programs.home-manager.enable = true;

      xdg.userDirs = {
        enable = true;
        documents = "$HOME/docs";
        download = "$HOME/dl";
        videos = "$HOME/vids";
        pictures = "$HOME/pics";
      };

      programs.git = {
        enable = true;
        userName = "${config.git.userName}";
        userEmail = "${config.git.userEmail}";
      };

      home.username = "${userName}";
      home.homeDirectory = "/home/${userName}";

      home.stateVersion = "24.05"; # Please read the comment before changing.
  };
}
