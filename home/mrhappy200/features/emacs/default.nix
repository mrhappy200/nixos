{
  inputs,
  pkgs,
  ...
}:
let
  myEmacs = inputs.hppyemacs.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  services.emacs = {
    client.enable = true;
    enable = true;
    package = myEmacs;
    socketActivation.enable = true;
    startWithUserSession = true;
  };

  programs.emacs = {
    enable = true;
    package = myEmacs;
    extraPackages = epkgs: [
      #epkgs.nix-mode
      #epkgs.nixfmt
    ];
  };
  stylix.targets.emacs.enable = false;
}
