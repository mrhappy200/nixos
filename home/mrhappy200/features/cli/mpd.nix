{ pkgs, config, ... }:
{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      playlistDirectory = "${config.home.homeDirectory}/Playlists";
      network = {
        startWhenNeeded = true;
      };
    };
    mpdris2 = {
      enable = true;
      multimediaKeys = true;
    };
  };
  programs.ncmpcpp = {
    enable = true;
  };
  home.packages = [ pkgs.mpc ];
}
