{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  imports = [
    ../features/cli
  ]
  ++ (builtins.attrValues outputs.homeManagerModules);

  disabledModules = [ "programs/vdirsyncer.nix" ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
    man.enable = true;
  };

  manual.manpages.enable = true;

  home = {
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    packages =
      let
      in
      [
        pkgs.libqalculate
        #pkgs.devenv
      ];
    persistence = {
      "/persist/" = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Music"
          "Playlists"
          "Videos"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
          ".config/sunshine"
          ".conda"
          ".cache"
        ];
      };
    };
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      NH_FLAKE = "$HOME/Documents/NixConfig";
    };
    stateVersion = lib.mkDefault "22.05";
    username = lib.mkDefault "mrhappy200";
  };
}
