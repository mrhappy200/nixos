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

nginx.virtualHosts."guac.berntsen.nl.eu.org" = {
  forceSSL = true;
  enableACME = true;
  locations."/".proxyPass = "http://localhost:8080";
};
}
