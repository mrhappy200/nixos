{pkgs, ...}: {
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    musicDirectory = "/home/mrhappy200/Music";
    playlistDirectory = "/home/mrhappy200/Playlists";
    extraConfig = ''
     audio_output {                                                                 
    type     "pipewire"                                                       
    name     "PipeWire Sound Server"                                           
    enabled  "yes"                                                             
}
     audio_output {
        type            "fifo"
        name            "Visualizer feed"
        path            "/tmp/mpd.fifo"
        format          "44100:16:2"
 }
'';
  };
  services.mpd-mpris.enable = true;
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {visualizerSupport = true;};
  };

  home.packages = [pkgs.mpc-cli];

  home.persistence = {
    "/nix/persist/home/mrhappy200/".directories = ["Music" "Playlists"];
  };
}
