{ pkgs, ... }: {
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
}
