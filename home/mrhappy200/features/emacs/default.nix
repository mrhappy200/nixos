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

  xdg.configFile."emacs/early-init.el".text = ''
    ;;; early-init.el -*- lexical-binding: t; -*-

    ;; Avoid GC during initialisation.  Restore a normal threshold in init.el.
    (setq gc-cons-threshold (* 128 1024 1024)
          gc-cons-percentage 0.6)

    ;; Build the initial frame without UI elements, instead of creating and
    ;; immediately removing them.
    (push '(menu-bar-lines . 0) default-frame-alist)
    (push '(tool-bar-lines . 0) default-frame-alist)
    (push '(vertical-scroll-bars . nil) default-frame-alist)

    (setq initial-major-mode 'fundamental-mode
          initial-scratch-message nil)
  '';

  home.persistence = {
    "/persist/".directories = [ "Documents/Snippets" ];
  };
}
