{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasRipgrep = hasPackage "ripgrep";
  hasExa = hasPackage "eza";
  hasNeovim = config.programs.neovim.enable;
  hasEmacs = config.programs.emacs.enable;
  hasNeomutt = config.programs.neomutt.enable;
in {
  home.persistence."/nix/persist/home/mrhappy200/" = {
    directories = [
      ".config/fish"
    ];
  };

  programs.fish = {
    enable = true;
    shellAbbrs = rec {
      jqless = "jq -C | less -r";

      n = "nix";
      nd = "nix develop -c $SHELL";
      ns = "nix shell";
      nsn = "nix shell nixpkgs#";
      nb = "nix build";
      nbn = "nix build nixpkgs#";
      nf = "nix flake";

      nr = "nixos-rebuild --flake .";
      nrs = "nixos-rebuild --flake . switch";
      snr = "sudo nixos-rebuild --flake .";
      snrs = "sudo nixos-rebuild --flake . switch";
      hm = "home-manager --flake .";
      hms = "home-manager --flake . switch";

      ls = mkIf hasExa "eza";
      exa = mkIf hasExa "eza";

      e = mkIf hasEmacs "emacsclient -t";

      vrg = mkIf (hasNeomutt && hasRipgrep) "nvimrg";
      vim = mkIf hasNeovim "nvim";
      vi = vim;
      v = vim;

      mutt = mkIf hasNeomutt "neomutt";
      m = mutt;
    };
    shellAliases = {
      # Clear screen and scrollback
      # clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
    };
    functions = {
      # Disable greeting
      fish_greeting = "";
      # Grep using ripgrep and pass to nvim
      nvimrg = mkIf (hasNeomutt && hasRipgrep) "nvim -q (rg --vimgrep $argv | psub)";
      # Merge history upon doing up-or-search
      # This lets multiple fish instances share history
      up-or-search =
        /*
        fish
        */
        ''
          if commandline --search-mode
            commandline -f history-search-backward
            return
          end
          if commandline --paging-mode
            commandline -f up-line
            return
          end
          set -l lineno (commandline -L)
          switch $lineno
            case 1
              commandline -f history-search-backward
              history merge
            case '*'
              commandline -f up-line
          end
        '';
    };
    interactiveShellInit =
      /*
      fish
      */
      ''
        # Open command buffer in vim when alt+e is pressed
        bind \ee edit_command_buffer

        # Use vim bindings and cursors
        fish_vi_key_bindings
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block

        #if not set -q TMUX
        #  ${pkgs.tmux}/bin/tmux new-session -A -s main
        #end
      '';
  };
}
