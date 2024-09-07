{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: let
in {
  imports =
    [
      inputs.impermanence.nixosModules.home-manager.impermanence
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "mrhappy200";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      # FLAKE = "$HOME/Documents/NixConfig";
    };

    persistence = {
      "/nix/persist/home/mrhappy200" = {
        directories = [
          "Downloads"
          "Werk"
          "persist"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
          ".config/Yubico"
        ];
        allowOther = true;
      };
    };
  };
  home.file = {
  };
}
