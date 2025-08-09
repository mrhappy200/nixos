{
  config,
  pkgs,
  ...
}: let
  inherit (config) colorscheme;
  hash = builtins.hashString "md5" (builtins.toJSON colorscheme.colors);
in {
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.COLORTERM = "truecolor";
}
