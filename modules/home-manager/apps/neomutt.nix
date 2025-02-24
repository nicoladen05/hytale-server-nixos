{ pkgs, lib, config, secrets, ... }:

{
  options = {
    apps.mail.neomutt.enable = lib.mkEnableOption "Enable the neomutt mail client";
  };

  config = lib.mkIf config.apps.mail.neomutt.enable {
    accounts.email.accounts.gmail = {
      address = secrets.accounts.gmail.address;
      userName = secrets.accounts.gmail.address;
      realName = secrets.accounts.real_name;
      passwordCommand = "echo ${secrets.accounts.gmail.password}";
      primary = true;
      maildir.path = "Mail";
      flavor = "gmail.com";

      neomutt = {
        enable = true;
        mailboxName = "Inbox";
        extraConfig = ''
          set ssl_force_tls = yes
          unmailboxes *
        '';
      };

      mbsync.enable = true;
      msmtp.enable = true;
    };

    programs.mbsync = {
      enable = true;
      package = pkgs.isync;
    };

    programs.msmtp = {
      enable = true;
    };

    programs.neomutt = {
      enable = true;
      vimKeys = true;
      sidebar.enable = true;
    };
  };
}
