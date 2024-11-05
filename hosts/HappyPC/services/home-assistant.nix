{ ... }:
let

in {

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" "/run/dbus:/run/dbus:ro" ];
      environment.TZ = "Europe/Berlin";
      image =
        "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ "--network=host" ];
    };
  };

  services.nginx.virtualHosts."home.hppy200.dev" = {
    forceSSL = true;
    sslCertificate = "/nix/persist/etc/nginx/certs/fullchain.pem";
    sslCertificateKey = "/nix/persist/etc/nginx/certs/privkey.pem";
    extraConfig = ''
      ssl_client_certificate /nix/persist/etc/nginx/certs/ca.crt;
      ssl_verify_client off;

      proxy_buffering off;
    '';

    locations."/" = {
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
      proxyPass = "http://127.0.0.1:8123";
    };
  };
  environment.persistence = {
    "/nix/persist".directories =
      [ "/var/lib/containers/storage/volumes/home-assistant" ];
  };
}

