{ pkgs, ... }: {
  home.packages = [
    pkgs.nmtui
    pkgs.nm-applet
  ];
}
