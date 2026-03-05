{ ... }:
{
  services.nginx.virtualHosts."guac.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      extraConfig = ''
        proxy_pass http://euphrosyne:8080/guacamole/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        client_max_body_size 1g;
        access_log off;
      '';
    };
  };
}
