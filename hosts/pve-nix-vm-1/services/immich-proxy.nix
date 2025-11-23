{config, ...}: {
  sops.secrets.immich_oidc-client-secret = {
    group = config.services.authelia.instances.plsFriend.group;
    mode = "770";
    sopsFile = ../secrets.yaml;
  };
  services.nginx.virtualHosts."photos.hppy200.dev" = {
    forceSSL = true;

    sslCertificate = "/var/lib/acme/hppy200.dev/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/hppy200.dev/key.pem";

    locations."/" = {
      proxyPass = "http://100.64.0.7:2283";
    };
  };
}
