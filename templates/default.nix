{...}: let
in {
  project-rust = {
    path = ./project/rust;
    description = "A (sorta) simple rust env";
  };

  nix = {
    registry = {
      happy = {
        from = {
          type = "path";
          path = "/etc/nixos/templates";
        };
      };
    };
  };
}
