{ config, ... }: {
  sops.secrets.uva-vpn-pass = {
    sopsFile = ../secrets.yaml;
  };
  networking.openconnect = {
    openconnect-uva0 = {
      gateway = "vpn.uva.nl";
      autoStart = false;
      protocol = "nc";
      user = "16942701@uva.nl";
      passwordFile = config.sops.secrets.uva-vpn-pass.path;
    };
  };
}
