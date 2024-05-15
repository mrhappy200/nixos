{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with inputs; {
  home.packages = [
    pkgs.neovim
    pkgs.tree-sitter
    pkgs.wl-clipboard
    pkgs.ripgrep
    pkgs.lazygit
    pkgs.bottom
    pkgs.python3
    pkgs.nodejs_21
    pkgs.git
  ];

  xdg.configFile = {
    "nvim" = {
      recursive = true;
      source = astronvim;
    };
    "nvim/lua/user" = {
      source = astronvim-user;
    };
  };

  home.persistence."/nix/persist/home/mrhappy200" = {
    directories = [
      ".cache/nvim"
      ".local/share/nvim"
      ".local/state/nvim"
    ];
    files = [];
  };
}
