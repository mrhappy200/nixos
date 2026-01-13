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
  };

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config" :
      [
        "~/.local/share/Steam/config"
      ],
      "external_drivers" : null,
      "jsonid" : "vrpathreg",
      "log" :
      [
        "~/.local/share/Steam/logs"
      ],
      "runtime" :
      [
        "${pkgs.xrizer}/lib/xrizer"
      ],
      "version" : 1
    }
  '';

  home = {
    username = lib.mkDefault "mrhappy200";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      NH_FLAKE = "$HOME/Documents/NixConfig";
    };

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
        ];
      };
    };
  };


  home.packages =
    let
    in
    [
      pkgs.devenv
    ];
}
