{...}: {
  services.nginx.virtualHosts."home.hppy200.dev" = {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";
    enableACME = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "homeassistant:8123";
      proxyWebsockets = true;
    };
  };
}
