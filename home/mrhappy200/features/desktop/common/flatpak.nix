{ ... }:
{
  services.flatpak.update.onActivation = true;
  services.flatpak.enable = true;
  home.persistence = {
    "/persist/" = {
      directories = [
        ".cache/flatpak"
        ".local/share/flatpak"
      ];
    };
  };
}
