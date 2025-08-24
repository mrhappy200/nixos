{
  pkgs,
  inputs,
  ...
}: let
  illogical-dots-HMmodule = inputs.illogical-impulse.homeManagerModules.default;
in {
  imports = [
    ../common
    ../common/wayland-wm
    illogical-dots-HMmodule
  ];

  home.packages = [
    pkgs.ydotool
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.rubik
    pkgs.starship
  ];

  illogical-impulse = {
    # Enable the dotfiles suite
    enable = true;

    hyprland = {
      # Use customized Hyprland build
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xdgPortalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

      # Enable Wayland ozone
      ozoneWayland.enable = true;
    };

    # Dotfiles configurations
    dotfiles = {
      fish.enable = true;
      kitty.enable = true;
    };
  };
}
