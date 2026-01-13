{config, ...}: let
in {
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "${config.fontProfiles.regular.name} ${
        toString config.fontProfiles.regular.size
      }";
      recolor = true;
          };
  };
}
