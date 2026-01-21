{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ wrtag rsgain ];
  xdg.configFile."wrtag/config".text = ''
    path-format ${config.home.homeDirectory}/Music/{{ artists .Release.Artists | sort | join "; " | safepath }}/({{ .Release.ReleaseGroup.FirstReleaseDate.Year }}) {{ .Release.Title | safepath }}{{ if not (eq .ReleaseDisambiguation "") }} ({{ .ReleaseDisambiguation | safepath }}){{ end }}/{{ pad0 2 .TrackNum }}.{{ len .Tracks | pad0 2 }} {{ if .IsCompilation }} - {{ end }}{{ .Track.Title | safepath }}{{ .Ext }}
    addon lyrics lrclib genius musixmatch
    addon replaygain true-peak
  '';
}
