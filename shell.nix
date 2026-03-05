{
  inputs,
  pkgs ? import <nixpkgs> { },
  ...
}:
let
  hppynvim = inputs.hppynvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      hppynvim
      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
