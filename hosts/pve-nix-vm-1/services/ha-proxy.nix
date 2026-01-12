{...}: {
  services.nginx.virtualHosts."home.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";
    extraConfig = ''
      proxy_buffering off;
    '';

    locations."/" = {
      extraConfig = ''
        set $backend "http://100.64.0.3:8123";
        proxy_pass $backend;
      '';
      proxyWebsockets = true;
    };
  };
}
