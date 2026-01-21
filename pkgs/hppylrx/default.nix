{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  mpd2,
  mutagen,
}:
let
  pylrcPkg = buildPythonPackage rec {
    pname = "pylrc";
    version = "0.1.2"; # or whatever the latest version is
    src = fetchPypi {
      inherit pname version;
      sha256 = "udage30hH3Epmz+upaHKZML8RePXBCJ8B8zbDMCThtE="; # compute with nix-prefetch-url
    };
    pyproject = true;
    build-system = [ setuptools ];
    doCheck = false;
  };

  hppylrx = buildPythonPackage rec {
    pname = "hppylrx";
    version = "0.0.1";
    src = ./.;
    propagatedBuildInputs = [
      pylrcPkg
      mutagen
      mpd2
    ];
    pyproject = true;
    build-system = [ setuptools ];
    doCheck = false;
  };
in
hppylrx
