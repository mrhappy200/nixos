{pkgs, ...}: let
in {
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
    '';
  };
  environment.persistence = {
    "/persist".directories = ["/var/lib/postgresql"];
  };
}
