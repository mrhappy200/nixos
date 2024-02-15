{ lib, inputs, pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "ls -l";
      switch = "sudo nixos-rebuild switch --flake /etc/nixos";
    };
    history = {
      save = 100000;
      path = ".histfile";
    };
  };

  home.persistence."/nix/persist/home/mrhappy200" = {
    directories = [
    ];
    files = [
      ".histfile"
    ];
  };

}
