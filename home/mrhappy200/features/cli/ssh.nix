{
  outputs,
  lib,
  config,
  ...
}:
let
  nixosConfigs = builtins.attrNames outputs.nixosConfigurations;
  homeConfigs = map (n: lib.last (lib.splitString "@" n)) (
    builtins.attrNames outputs.homeConfigurations
  );
  hostnames = lib.unique (homeConfigs ++ nixosConfigs);
in
{
  # Persisting known_hosts with impermance is wonky, as SSH sometimes
  # overwrites it. My workaround is to make a known_hosts.d directory instead,
  # which is persisted.
  home.persistence = {
    "/persist/".directories = [ ".ssh/known_hosts.d" ];
  };

  programs.ssh = {
    enable = true;
    # See above
    enableDefaultConfig = false;
    settings = {
      net = {
        host = lib.concatMapStringsSep " " (h: "${h} ${h}.hppy200.dev ${h}.ts.hppy200.dev") hostnames;
        UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts.d/hosts";
        ForwardAgent = true;
        ForwardX11 = true;
        ForwardX11Trusted = true;
        SetEnv = {
          WAYLAND_DISPLAY = "wayland-waypipe";
        };
        RemoteForward = [
          "/%d/.gnupg-sockets/S.gpg-agent /%d/.gnupg-sockets/S.gpg-agent.extra"
          "/%d/.waypipe/server.sock /%d/.waypipe/client.sock"
        ];
        StreamLocalBindUnlink = "yes";
      };
    };
  };

  # Compatibility with programs that don't respect SSH configurations (e.g. jujutsu's libssh2)
  #systemd.user.tmpfiles.rules = [
  #  "L ${config.home.homeDirectory}/.ssh/known_hosts - - - - ${config.programs.ssh.matchBlocks.net.userKnownHostsFile}"
  #];
}
