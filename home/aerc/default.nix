{ pkgs, config, ... }: {
  programs.aerc = {
    enable = true;

    extraBinds = builtins.readFile "${pkgs.aerc}/share/aerc/binds.conf";

    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
      };
      ui = {
        timestamp-format = "2006-01-02 15:04";
        mouse-enabled = true;
        border-char-vertical = "│";
        border-char-horizontal = "─";
        threading-enabled = true;
        dirlist-tree = true;
        dirlist-collapse = 1;
      };
      filters = {
        "text/plain" = "colorize | ${pkgs.busybox}/bin/fold -sw100";
        "text/html" = "html-unsafe | colorize";
      };
    };

    stylesets = {
      default = ''
        # should work with any terminal colorscheme, but was designed for gruvbox
        # terminal colors are preferred, but hex is used for grayscale

        *.default=true
        *.normal=true

        # present in 'Send this email?' dialog
        title.fg=yellow
        title.bg=#303030
        title.bold=true

        # used in setup and in 'From:' etc
        header.bold=true
        header.fg=purple

        # decorative lines
        border.fg=blue

        # requires attention
        *error.bold=true
        *error.fg=red
        *error.blink=true
        *warning.fg=yellow
        *warning.blink=true
        *success.fg=green

        # statusline
        statusline_default.fg=gray
        statusline_*.bg=#303030

        # message list colors
        msglist_deleted.fg=gray
        msglist_unread.fg=green
        msglist_read.fg=blue
        msglist_marked.fg=yellow
        msglist_marked.reverse=true

        # inbox etc
        dirlist_default.fg=gray

        # highlight selected item
        *.selected.bg=#3a3a3a
        *.selected.fg=white
        *.selected.bold=true

        # primarily used in account setup
        selector_default.fg=gray
        selector_chooser.bold=true
        selector_focused.bg=#3a3a3a
        selector_focused.bold=true

        # command completion
        completion_default.bg=#303030
        completion_gutter.bg=#303030
        completion_pill.bg=aqua
      '';
    };
  };

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
