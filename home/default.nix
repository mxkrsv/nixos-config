{ pkgs, config, lib, ... }: {
  programs.home-manager.enable = true;

  imports = [
    ./nixvim
    ./age
    ./accounts
    ./aerc
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
    fastfetch
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

  home.pointerCursor = {
    name = "Adwaita";
    size = 24;
    package = pkgs.gnome3.adwaita-icon-theme;
  };

  xdg.configFile = {
    fastfetch = {
      source = ./files/fastfetch.jsonc;
      target = "fastfetch/config.jsonc";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
    enableCompletion = true;
    dotDir = ".config/zsh";
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "agnoster-multiline";
        src = pkgs.fetchFromGitHub {
          owner = "mxkrsv";
          repo = "agnoster-multiline";
          rev = "609e66a3258076cb01ac53123c5a0c4aea65de6d";
          hash = "sha256-sS1bR0PAhEu3ToS+erSMlOqoCyHaEB9D8TLuOvk9Dto=";
        };
      }
    ];
    initExtra = ''
      # general options
      setopt nomatch notify pipefail shwordsplit

      # fix some keys behavior for vi mode
      bindkey  "^[[H" beginning-of-line
      bindkey  "^[[F" end-of-line
      bindkey '^P' up-history
      bindkey '^N' down-history
      bindkey "^?" backward-delete-char
      bindkey "^W" backward-kill-word
      bindkey "^H" backward-delete-char
      bindkey "^U" backward-kill-line

      # beautiful ls
      alias ls='ls -hF --color=tty'

      # enable colors
      autoload -Uz colors && colors

      # default black comments are invisible on black bg
      #ZSH_HIGHLIGHT_STYLES[comment]=fg=cyan,bold

      # fzf-tab setup
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      #zstyle ':completion:*' list-colors $\{(s.:.)LS_COLORS\}
      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -hAF --color=always "$realpath"'
      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'

      # set terminal title
      precmd() { print -Pn "\e]0;zsh %~%(1j, (%j job%(2j|s|)) ,)\e\\"; }
      preexec() { print -Pn "\e]0;$\{(q)1\}\e\\"; }
    '';
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

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
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
      pinentry = "gnome3";
    };
  };

  programs.khal = {
    enable = true;

    locale = {
      timeformat = "%H:%M";
      dateformat = "%d.%m";
      longdateformat = "%d.%m.%Y";
      datetimeformat = "%d.%m %H:%M";
      longdatetimeformat = "%d.%m.%Y %H:%M";
    };
  };

  programs.vdirsyncer = {
    enable = true;
  };

  programs.starship = {
    enable = true;

    enableTransience = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        #"[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_blue)"
        "$c"
        "$rust"
        "$golang"
        "$haskell"
        "[](fg:color_blue bg:color_bg3)"
        "$nix_shell"
        "[](fg:color_bg3 bg:color_bg1)"
        "$cmd_duration"
        "[](fg:color_bg1)"
        "$line_break$character"
      ];

      palette = "terminal";

      palettes.terminal = {
        color_fg0 = "black";
        color_bg1 = "white";
        color_bg3 = "black";
        color_blue = "blue";
        color_aqua = "cyan";
        color_green = "green";
        color_orange = "yellow";
        color_purple = "purple";
        color_red = "red";
        color_yellow = "bright-yellow";
      };

      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };

      username = {
        show_always = false;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[ $user ]($style)";
      };

      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };

      git_status = {
        style = "bg:color_aqua";
        format = "[[($all_status$ahead_behind) ](fg:color_fg0 bg:color_aqua)]($style)";
      };

      c = {
        symbol = "c";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      rust = {
        symbol = "rs";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      golang = {
        symbol = "go";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      haskell = {
        symbol = "hs";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      nix_shell = {
        symbol = "nix";
        style = "bg:color_bg3";
        heuristic = true;
        format = "[[ $symbol( $name) ](fg:color_blue bg:color_bg3)]($style)";
      };

      cmd_duration = {
        disabled = false;
        style = "bg:color_bg1";
        format = "[[ 🕓 $duration ](fg:color_fg0 bg:color_bg1)]($style)";
      };

      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;
        success_symbol = "[](bold fg:color_green)";
        error_symbol = "[](bold fg:color_red)";
        vimcmd_symbol = "[](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
        vimcmd_replace_symbol = "[](bold fg:color_purple)";
        vimcmd_visual_symbol = "[](bold fg:color_yellow)";
      };
    };
  };

  # E.g. for "command not found"
  programs.nix-index.enable = true;
}
