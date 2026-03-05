{
  config,
  pkgs,
  lib,
  ...
}:
let
in
{
  services.postgresql = {
    enable = true;
    identMap = ''
      # ArbitraryMapName systemUser DBUser
           superuser_map      root      postgres
           superuser_map      postgres  postgres
           # Let other names login as themselves
           superuser_map      /^(.*)$   \1
    '';
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host    tomcat          tomcat          100.64.0.4/32           scram-sha-256
    '';
    settings = {
      listen_addresses = lib.mkForce "localhost, pve-nix-vm-1, 100.64.0.2";
    };
  };
  services.postgresql.ensureDatabases = [ config.services.tomcat.user ];
  services.postgresql.ensureUsers = [
    {
      name = config.services.tomcat.user;
      ensureDBOwnership = true;
      ensureClauses = {
        password = "SCRAM-SHA-256$4096:GgHPO5dpYN7YQkKWAp0icA==$XibYm1zpJVUFCtpNxtsR6m5pJqt8W1pyTmzZbhPlC2c=:/YUoBYx5WftdVsc/DZjC7E434UpxIdU1AeK4w4nLtbI=";
      };
    }
  ];
  environment.persistence = {
    "/persist".directories = [ "/var/lib/postgresql" ];
  };
}
