#{ pkgs, ... }:
#let
#in
#{
#  home.packages = [ pkgs.blender ];
#  home.persistence = {
#    "/persist/" = {
#      directories = [ ".config/blender/" ];
#    };
#  };
#}

{ pkgs, ... }:
let
  # Override Blender to enable HIP and disable OSL/LLVM
  blender-hip-fixed =
    (pkgs.blender.override {
      rocmSupport = true;
    }).overrideAttrs
      (old: {
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          "-DWITH_CYCLES_OSL=OFF"
          "-DWITH_LLVM=OFF"
        ];
      });
in
{
  home.packages = [ pkgs.pkgsRocm.blender ];
  home.persistence = {
    "/persist/" = {
      directories = [ ".config/blender/" ];
    };
  };
}
