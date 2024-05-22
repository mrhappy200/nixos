{
  services.guacamole-server = {
    enable = true;
    host = "127.0.0.1";
    userMappingXml = ./user-mapping.xml;
  };

  services.guacamole-client = {
    enable = true;
    enableWebserver = true;
    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };
  };

  services.nginx.virtualHosts."guac.berntsen.nl.eu.org" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://localhost:8080/guacamole";
    locations."/guacamole".proxyPass = "http://localhost:8080/guacamole";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.fluxbox.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "fluxbox";
  services.xrdp.openFirewall = true;
}
