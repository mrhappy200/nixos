{ lib, inputs, pkgs, config, nixVim, ... }:

{
  home.packages = [
    pkgs.neovim
  ];

  programs.nixvim = {
    enable = true;
  };

  # xdg.configFile = {
  #   "nvim" = {
  #     recursive = true;
  #     source = astronvim;
  #   };
  #   "nvim/lua/user" = {
  #     source = astronvim-user;
  #   };
  # };

  home.persistence."/nix/persist/home/mrhappy200" = {
    directories = [
      ".cache/nvim"
      ".local/share/nvim"
      ".local/state/nvim"
    ];
    files = [ ];
  };
}
