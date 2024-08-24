{
  pkgs,
  config,
  ...
}: let
  url = "changedetection.hppy200.dev";
  address = "localhost";
  port = 5397;
  envFile = ''
    HIDE_REFERER=false
    SALTED_PASS=${config.sops.placeholder.changedetectionio-pass}
  '';
in {
  sops.secrets.changedetectionio-pass = {sopsFile = ../secrets.yaml;};

  sops.templates."changedetectionio-env".content = "${envFile}";
  services.changedetection-io = {
    enable = true;
    behindProxy = true;
    playwrightSupport = true;
    port = port;
    listenAddress = address;
    baseURL = url;
    environmentFile = config.sops.templates."changedetectionio-env".path;
  };

  services.nginx.virtualHosts."${toString url}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${toString address}:${toString port}";
    };
  };

  environment.persistence = {
    "/nix/persist" = {
      directories = ["${toString config.services.changedetection-io.datastorePath}"];
    };
  };
}
