{ userName, inputs, lib, config, ... }:

{
  imports =
    [
      ./terminal
      ./desktop
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
        default = "nicolashartmanntaba@gmail.com";
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
