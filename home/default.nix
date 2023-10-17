{ pkgs, config, ... }: {
  programs.home-manager.enable = true;

  imports = [
    ./nixvim
    ./age
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
    neofetch
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
    neofetch = {
      source = ./files/neofetch.conf;
      target = "neofetch/config.conf";
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
      { url = "https://repology.org/maintainer/begs%40disroot.org/feed-for-repo/alpine_edge/atom"; }
      { url = "https://repology.org/maintainer/mxkrsv%40disroot.org/feed-for-repo/alpine_edge/atom"; }
      { url = "https://alpinelinux.org/atom.xml"; }
      { url = "https://postmarketos.org/blog/feed.atom"; }
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
    '';
  };

  programs.rbw = {
    enable = true;
    settings = {
      email = "mxkrsv@disroot.org";
      pinentry = "gnome3";
    };
  };
}
