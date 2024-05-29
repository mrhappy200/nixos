{
  lib,
  config,
  ...
}: let
  inherit (config.networking) hostName;
in {
  services = {
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "300m";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
