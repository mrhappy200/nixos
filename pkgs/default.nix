# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: rec {
  # example = pkgs.callPackage ./example { };
  pass-wofi = pkgs.callPackage ./pass-wofi {};
  firefly-iii-data-importer = pkgs.callPackage ./firefly-iii-data-importer {};
  firefly-iii = pkgs.callPackage ./firefly-iii {};
  HappyRaspi = pkgs.callPackage ./HappyRaspi {};
}
