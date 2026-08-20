{ pkgs, ... }:
{
  #home.packages = [ pkgs.openscad ];
  services.flatpak.packages = [
    rec {
      appId = "com.orcaslicer.OrcaSlicer";

      # Generate this hash via terminal: nix-prefetch-url <github-release-url>
      sha256 = "0z0i3lmk5ns9gg7z37j3lwj388rkyjxav5fcm3id6l8kn35cj7nq";

      bundle = "${pkgs.fetchurl {
        # Replace this URL with the exact nightly build you are targeting
        url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/nightly-builds/OrcaSlicer-Linux-flatpak_nightly_x86_64.flatpak";
        inherit sha256;
      }}";
    }
  ];
  home.persistence = {
    "/persist/" = {
      directories = [
        ".config/OrcaSlicer"
        ".local/share/orca-slicer"
        ".var/app/com.orcaslicer.OrcaSlicer"
      ];
    };
  };
}
