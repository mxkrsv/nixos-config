{ pkgs, ... }: {
  accounts.email.accounts = {
    Personal = {
      primary = true;
      address = "mxkrsv@disroot.org";
      userName = "mxkrsv@disroot.org";
      realName = "Maxim Karasev";
      passwordCommand = "${pkgs.rbw}/bin/rbw get disroot.org";
      imap = {
        host = "disroot.org";
        tls.enable = true;
      };
      smtp = {
        host = "disroot.org";
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      folders.inbox = "INBOX";
      aerc.enable = true;
    };

    Second = {
      address = "begs@disroot.org";
      userName = "begs@disroot.org";
      realName = "Maxim Karasev";
      passwordCommand = "${pkgs.rbw}/bin/rbw get disroot.org-old";
      imap = {
        host = "disroot.org";
        tls.enable = true;
      };
      smtp = {
        host = "disroot.org";
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      folders.inbox = "INBOX";
      aerc.enable = true;
    };

    University = {
      flavor = "yandex.com";
      address = "makarasev@stud.etu.ru";
      userName = "makarasev@stud.etu.ru";
      realName = "Maxim Karasev";
      passwordCommand = "${pkgs.rbw}/bin/rbw get stud.etu.ru-aercapppassword";
      folders.inbox = "INBOX";
      aerc.enable = true;
    };
  };
}
