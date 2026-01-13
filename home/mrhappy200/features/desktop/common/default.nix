{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./deluge.nix
    ./discord.nix
    ./dragon.nix
    ./firefox.nix
    ./font.nix
    #    ./gtk.nix
    ./kdeconnect.nix
    ./pavucontrol.nix
    ./mpv.nix
    ./playerctl.nix
    #    ./qt.nix
  ];

  home.packages = [
    pkgs.libnotify
    pkgs.handlr-regex
    (pkgs.writeShellScriptBin "xterm" ''
      handlr launch x-scheme-handler/terminal -- "$@"
    '')
    (pkgs.writeShellScriptBin "xdg-open" ''
      handlr open "$@"
    '')
  ];

  xdg.portal.enable = true;
}
