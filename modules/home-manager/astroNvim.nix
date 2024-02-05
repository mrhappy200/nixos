{ inputs, pkgs, config, ... }:

with inputs;


{
  home.packages = [
  pkgs.neovim
  pkgs.nerdfonts
  pkgs.tree-sitter
  pkgs.wl-clipboard
  pkgs.ripgrep
  pkgs.lazygit
  pkgs.bottom
  pkgs.python3
  pkgs.nodejs_21
  pkgs.git
];

home.file = {
  "nvim/lua/user" = {
    source = "${astronvim-user}";
  };
};

xdg.configFile = {
  nvim = {
    source = "${astronvim}";
  };
};}
