{...}: let
in {
  virtualisation.waydroid.enable = true;

  #binfmt.registrations."android-x86_64" = {
  #  interpreter = pkgs.waydroid;
  #};
}
