{lib, config, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = lib.mkForce true;
    };
  };
}
