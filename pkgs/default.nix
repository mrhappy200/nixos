{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  # # Packages with an actual source
  #lyrics = pkgs.python3Packages.callPackage ./lyrics { };

  # # Personal scripts
  minicava = pkgs.callPackage ./minicava { };
  pass-wofi = pkgs.callPackage ./pass-wofi { };
  xpo = pkgs.callPackage ./xpo { };
  hppylrx = pkgs.python3Packages.callPackage ./hppylrx { };
  faline = pkgs.python3Packages.callPackage ./faline { };

  #moondeck-buddy lifted from PR: 375287
  moondeck-buddy = pkgs.callPackage ./moondeck-buddy { };

  # # My slightly customized plymouth theme, just makes the blue outline white
  plymouth-spinner-monochrome = pkgs.callPackage ./plymouth-spinner-monochrome { };
}
