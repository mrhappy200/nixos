{ ... }: {
  services.nginx.virtualHosts."latex.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      extraConfig = ''
        set $backend "http://100.64.0.4:8974";
        proxy_pass $backend;
      '';
    };
  };
}
