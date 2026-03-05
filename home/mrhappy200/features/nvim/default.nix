{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config) colorscheme;
  hash = builtins.hashString "md5" (builtins.toJSON colorscheme.colors);
in
{
  home.packages = [ inputs.hppynvim.packages.${pkgs.system}.default ];
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.COLORTERM = "truecolor";
}
