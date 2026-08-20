{
  pkgs,
  inputs,
  ...
}:
let
  split-monitor-workspaces =
    inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces;
in
{
  wayland.windowManager.hyprland = {
    plugins = [ split-monitor-workspaces ];
  };
}
