{ lib, ... }: {
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
}
