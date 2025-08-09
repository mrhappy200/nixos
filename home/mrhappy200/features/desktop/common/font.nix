{pkgs, ...}: {
  fontProfiles = {
    enable = true;
    monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    regular = {
      name = "IBM Plex Serif";
      package = pkgs.ibm-plex;
    };
  };
}
