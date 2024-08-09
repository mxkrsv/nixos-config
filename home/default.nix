{ pkgs, config, ... }: {
  programs.home-manager.enable = true;

  imports = [
    ./nixvim

    ./age

    ./accounts

    ./starship
    ./zsh

    ./apps
  ];

  home = {
    username = "mxkrsv";
    homeDirectory = "/home/mxkrsv";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      DEFAULT_USER = "$(whoami)";
    };
  };

  home.packages = with pkgs; [
    # text programs
    cmus
    texlive.combined.scheme-full
    libqalculate
    gnupg

    # utils
    jq
    ripgrep
    pdfgrep
    file
    ffmpeg
    strace
    gdb
    hyperfine

    paratype-pt-mono

    # dev
    gcc
    go
    gnumake
    cargo
    rustc
    ghc
    (python3.withPackages (ps: with ps; [
      ipython
      sympy
    ]))
    valgrind

    # language servers
    nil
    nixpkgs-fmt
    gopls
    clang-tools
    texlab

    # pwn
    nmap
    ffuf
    netcat-gnu
    (rizin.withPlugins (ps: with ps; [
      rz-ghidra
      sigdb
    ]))
  ];

  # nicely reload system units when changing configs
  # and also set global session variables in a way
  # that they will also be available to user services and all started programs,
  # not just those that was started via shell
  systemd.user = {
    startServices = "sd-switch";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.newsboat = {
    enable = true;
    autoReload = true;

    urls = [
      { url = "https://alpinelinux.org/atom.xml"; }
      { url = "https://postmarketos.org/blog/feed.atom"; }
      { url = "https://www.linux.org.ru/section-rss.jsp?section=1"; }
      { url = "https://www.opennet.ru/opennews/opennews_all_utf.rss"; }
      { url = "https://www.phoronix.com/rss.php"; }
      { url = "https://sourcehut.org/blog/index.xml"; }
      { url = "https://drewdevault.com/blog/index.xml"; }
      { url = "https://emersion.fr/blog/atom.xml"; }
      { url = "https://ariadne.space/index.xml"; }
    ];
    extraConfig = ''
      # vi-like bindings
      bind-key j down
      bind-key k up
      bind-key J next-feed articlelist
      bind-key K prev-feed articlelist
      bind-key G end
      bind-key g home
      bind-key d pagedown
      bind-key u pageup
      bind-key l open
      bind-key h quit
      bind-key a toggle-article-read
      bind-key n next-unread
      bind-key N prev-unread
      bind-key D pb-download
      bind-key U show-urls
      bind-key x pb-delete

      # limit width so articles are more readable
      text-width 80

      # based on /usr/share/doc/newsboat/contrib/colorschemes/gruvbox
      color background	color223	default
      color listnormal	color4		default
      color listnormal_unread	color2		default
      color listfocus		color223	color237	bold
      color listfocus_unread	color223	color237	bold
      color info		color8		color0
      color article		color223	default

      # highlights
      highlight article "^(Feed|Link):.*$" color11 default bold
      highlight article "^(Title|Date|Author):.*$" color11 default bold
      highlight article "https?://[^ ]+" color2 default underline
      highlight article "\\[[0-9]+\\]" color2 default bold
      highlight article "\\[image\\ [0-9]+\\]" color2 default bold
      highlight feedlist "^─.*$" color6 color6 bold
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  services.ssh-agent.enable = true;

  programs.lf = {
    enable = true;
    settings = {
      scrolloff = 3;
    };
    keybindings = {
      D = "delete";
      "<delete>" = "delete";
      T = "trash";
      "<esc>" = "quit";
      "<enter>" = "open";
      "o" = "terminal";
    };
    extraConfig = ''
      $mkdir -p ~/.trash
      cmd trash %set -f; mv "$fx" ~/.trash
      cmd terminal &${pkgs.foot}/bin/footclient
      set mouse
    '';
  };

  programs.git = {
    enable = true;
    userName = "Maxim Karasev";
    userEmail = "mxkrsv@disroot.org";
    extraConfig = {
      rebase = {
        autosquash = true;
      };
      sendemail = {
        smtpserver = "disroot.org";
        smtpuser = "mxkrsv@disroot.org";
        smtpencryption = "tls";
        smtpserverport = 587;
      };

      # Unbreak mouse scrolling
      core.pager = "less -+X";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.tmux = {
    enable = true;

    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    escapeTime = 1;
    historyLimit = 20000;
    terminal = "tmux-256color";

    extraConfig = ''
      set -ga terminal-overrides 'linux:colors=16'	# weird but helps
      set -ga terminal-overrides 'foot:Tc'		# truecolor

      set -g repeat-time 0

      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      bind Tab last-window

      # default statusbar colors
      set-option -g status-style "fg=#bdae93,bg=#3c3836"

      # default window title colors
      set-window-option -g window-status-style "fg=#bdae93,bg=default"

      # active window title colors
      set-window-option -g window-status-current-style "fg=#fabd2f,bg=default"

      # pane border
      set-option -g pane-border-style "fg=#b16286"
      set-option -g pane-active-border-style "fg=#8ec07c"

      # message text
      set-option -g message-style "fg=#d5c4a1,bg=#3c3836"

      # pane number display
      set-option -g display-panes-active-colour "#b8bb26"
      set-option -g display-panes-colour "#fabd2f"

      # clock
      set-window-option -g clock-mode-colour "#b8bb26"

      # copy mode highligh
      set-window-option -g mode-style "fg=#bdae93,bg=#504945"

      # bell
      set-window-option -g window-status-bell-style "fg=#3c3836,bg=#fb4934"
    '';
  };

  programs.htop = {
    enable = true;
    settings = {
      color_scheme = 0;
      cpu_count_from_one = 0;
      delay = 15;

      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;

      show_cpu_frequency = 1;
      show_cpu_temperature = 1;
    } // (with config.lib.htop; leftMeters [
      (bar "AllCPUs2")
    ]) // (with config.lib.htop; rightMeters [
      (bar "Memory")
      (bar "Swap")
      (text "Tasks")
      (text "LoadAverage")
      (text "Uptime")
      (text "Systemd")
      (text "DiskIO")
      (text "NetworkIO")
    ]);
  };

  home.stateVersion = "23.05";

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block

      # Disable greeting
      set fish_greeting
    '';

    functions = {
      # Render the short version of the prompt
      # TODO: maybe show the command status (would have to use a postexec hook)
      starship_transient_prompt_func = ''
        starship module character
      '';
    };
  };

  programs.rbw = {
    enable = true;
    settings = {
      email = "mxkrsv@disroot.org";
      pinentry = pkgs.pinentry.gnome3;
    };
  };

  # E.g. for "command not found"
  programs.nix-index.enable = true;

  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "nixos_old_small";
        padding = {
          top = 1;
          left = 2;
        };
      };

      display = {
        separator = "";
        key.width = 10;
      };

      modules = [
        "title"
        "break"
        {
          type = "os";
          key = "os";
          format = "{3}";
        }
        {
          type = "host";
          key = "host";
        }
        {
          type = "kernel";
          key = "kernel";
        }
        {
          type = "uptime";
          key = "uptime";
        }
        {
          type = "packages";
          key = "pkgs";
        }
        {
          type = "shell";
          key = "shell";
        }
        {
          type = "display";
          key = "video";
        }
        {
          type = "de";
          key = "de";
        }
        {
          type = "wm";
          key = "wm";
          format = "{1}";
        }
        {
          type = "terminal";
          key = "term";
        }
        "break"
        {
          type = "cpu";
          key = "cpu";
          format = "{1}";
        }
        {
          type = "gpu";
          key = "gpu";
          format = "{2}";
        }
        {
          type = "memory";
          key = "memory";
          format = "{1} / {2}";
        }
        {
          type = "disk";
          key = "disk";
          format = "{1} / {2} ({9})";
        }
        {
          type = "battery";
          key = "bat";
        }
        {
          type = "poweradapter";
          key = "pwr";
        }
      ];
    };
  };
}
