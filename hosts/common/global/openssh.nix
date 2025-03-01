{
  outputs,
  lib,
  config,
  ...
}: let
  hosts = lib.attrNames outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  hasOptinPersistence = config.environment.persistence ? "/nix/persist";
in {
  services.fail2ban = {
    enable = true;
    maxretry = 3;
  };
  services.openssh = {
    enable = true;
    ports = [8022];
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "${lib.optionalString hasOptinPersistence "/nix/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.mosh.enable = true;

  programs.ssh = {
    # Each hosts public key
    knownHosts = lib.genAttrs hosts (hostname: {
      publicKeyFile = ../../${hostname}/ssh_host_ed25519_key.pub;
      extraHostNames =
        [
          "${hostname}.hppy200.dev"
        ]
        ++
        # Alias for localhost if it's the same host
        (lib.optional (hostname == config.networking.hostName) "localhost");
    });
  };

  # Keep SSH_AUTH_SOCK when sudo'ing
  security.sudo.extraConfig = ''
    Defaults env_keep+=SSH_AUTH_SOCK
  '';
}
