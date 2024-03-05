{ config, pkgs, inputs, outputs, ... }:


{
  imports = [
    ../../modules/home-manager/astroNvim.nix
    # ../../modules/home-manager/nixVim.nix
    ../../modules/home-manager/hyprland
    # ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/foot.nix
    ../../modules/home-manager/monitors.nix
    ../../modules/home-manager/tofi.nix
    ../../modules/home-manager/mpd.nix
    # ../../modules/home-manager/activitywatch.nix
    # inputs.impermanence.nixosModules.home-manager.impermanence
    # inputs.nixvim.homeManagerModules.nixvim
  ];

  # home.persistence."/nix/persist/home/mrhappy200" = {
  #   directories = [
  #   ".gnupg"
  #   "werk"
  #   "Sync"
  #   ];
  #   files = [ ];
  # };

  # monitors = [
  #   {
  #     name = "eDP-1";
  #     width = 1366;
  #     height = 768;
  #     x = 1024;
  #     y = 1080;
  #     workspace = "1";
  #     primary = true;
  #   }
  #   {
  #     name = "HDMI-A-1";
  #     width = 1024;
  #     height = 600;
  #     x = 0;
  #     y = 0;
  #     workspace = "2";
  #   }
  #   {
  #     name = "DP-1";
  #     width = 1920;
  #     height = 1080;
  #     x = 1024;
  #     y = 0;
  #     workspace = "3";
  #   }
  # ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mrhappy200";
  home.homeDirectory = "/home/mrhappy200";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.bat
    pkgs.ripgrep
    pkgs.gcc
    pkgs.mpv
    pkgs.lf
    pkgs.fzf
    pkgs.bfs
    pkgs.broot
    pkgs.waypipe
    (pkgs.nerdfonts.override
      { fonts = [ "FantasqueSansMono" "FiraCode" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.configFile = { };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mrhappy200/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
