{ ... }: {
  services.nginx.virtualHosts."latex.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = { proxyPass = "debianproxmox:8974"; };
  };
}
