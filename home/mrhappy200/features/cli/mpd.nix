{ pkgs, config, ... }:
{


  services = {
    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      playlistDirectory = "${config.home.homeDirectory}/Playlists";

      network = {
        startWhenNeeded = true;
	listenAddress = "any";
        port = 6600;
      };



      extraConfig = ''
                audio_output {
                    type                    "fifo"
                    name                    "Cava"
                    path                    "/tmp/mpd.fifo"
                    format                  "44100:16:2"
                }
		audio_output {
		    type        "fifo"
		    encoder     "flac"
		    name        "snapserver"
		    format      "44100:16:2"
			path		"/run/snapserver/snapfifo"
			mixer_type	"software"
		}
                audio_output {
                        type            "pipewire"
                        name            "PipeWire Sound Server"
                }
        	audio_output {
        	    type        "httpd"
        	    name        "httpHppyRadio"
        	#using mp3 format for compatibility
        	    encoder     "lame"
        	#I use 8000 here, but you can use whatever port you like
        	    port        "8000"
        	    always_on   "yes"
        	    replay_gain_handler "software"
        	    tags        "yes"
        	# do not define bitrate if quality is defined
        	    bitrate     "64"
        	    format      "22050:16:1"

        	# I specified a lower bitrate because I didn't
        	# want to take up a bunch of data.
        	# An example of higher bitrate is below.
        	# do not define bitrate if quality is defined
        	#   bitrate     "128"
        	#   format      "44100:16:1"
        	}
        	zeroconf_enabled        "yes"
        	zeroconf_name           "MPD"

        	# Volume Normalisation
        	replaygain         "track"
        	replaygain_preamp       "0"
        	volume_normalization        "yes"
      '';
    };
    mpdris2 = {
      enable = true;
      multimediaKeys = true;
    };
  };
  programs.ncmpcpp = {
    enable = true;
  };
  home.packages = [
    pkgs.mpc
    pkgs.hppylrx
  ];
}
