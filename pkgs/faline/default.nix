{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  paho-mqtt,
}:
let
  faline = buildPythonPackage rec {
    pname = "faline";
    version = "0.0.1";
    src = ./.;
    propagatedBuildInputs = [
      paho-mqtt
    ];
    pyproject = true;
    build-system = [ setuptools ];
    doCheck = false;
  };
in
faline
