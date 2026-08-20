{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Qt xcb platform plugin deps (the main culprits)
      xorg.libX11 # libX11.so.6 + libX11-xcb.so.1
      xorg.libXi # libXi.so.6
      xorg.libSM # libSM.so.6
      xorg.libICE # libICE.so.6
      xorg.libxcb # libxcb.so.1
      xorg.libXrender # libXrender.so.1
      xorg.libXext # libXext.so.6
      xorg.xcbutil
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil

      # Graphics
      libGL # libGL.so.1
      libglvnd
      vulkan-loader

      # Fonts
      fontconfig # libfontconfig.so.1
      freetype # libfreetype.so.6

      # GLib / threading
      glib # libglib-2.0.so.0 + libgthread-2.0.so.0
      glibc
      glibc.dev

      # C++ stdlib
      stdenv.cc.cc.lib # libstdc++.so.6

      # SDL / audio (already working but keep them)
      SDL2
      libpulseaudio
      libxkbcommon
    ];
  };
}
