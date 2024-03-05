{ lib, inputs, pkgs, config, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      l = "ls -l";
      nswitch = "sudo nixos-rebuild switch --flake /etc/nixos";
    };
  };

  home.persistence."/nix/persist/home/mrhappy200" = {
    directories = [
      ".local/share/fish/"
    ];
    files = [
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
