{pkgs, ...}: {
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    autoStart = true;
    openFirewall = true;
    settings = {
      sunshine_name = "HappyPC";
    };
  };
}
