{
  outputs,
  lib,
  ...
}: let
  hostnames = builtins.attrNames outputs.nixosConfigurations;
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      net = {
        host = builtins.concatStringsSep " " hostnames;
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = ''/%d/.gnupg-sockets/S.gpg-agent'';
            host.address = ''/%d/.gnupg-sockets/S.gpg-agent.extra'';
          }
        ];
      };
      trusted = lib.hm.dag.entryBefore ["net"] {
        host = "berntsen.nl.eu.org *.berntsen.nl.eu.org *.hap.py";
        forwardAgent = true;
      };
    };
  };

  home.persistence = {
    "/nix/persist/home/mrhappy200".directories = [".ssh"];
  };
}
