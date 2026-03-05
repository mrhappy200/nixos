{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  programs.eww = {
    enable = true;
    enableFishIntegration = true;
  };

  systemd.user.services.eww = {
    Unit = {
      Description = "ElKowars wacky widgets";
      Documentation = "https://elkowar.github.io/eww/";
      After = [
        "hyprpaper.service"
        "graphical-session.target"
      ];
      PartOf = "graphical-session.target";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      Restart = "on-failure";
      ExecStart = "${lib.getExe pkgs.eww} daemon --no-daemonize";
    };
  };

  systemd.user.services.eww-open = {
    Unit = {
      Description = "Open appropriate EWW widgets (and insert random colour into config)";
      Documentation = "https://elkowar.github.io/eww/";
      Requires = "eww.service";
      After = [
        "eww.service"
        "graphical-session.target"
      ];
      PartOf = "eww.service";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.writeShellScript "Start EWW" ''
        #/usr/bin/env bash
        echo "random: ${osConfig.custom-stylix.randomColourPath}"
        echo "theme: ${osConfig.custom-stylix.theme}"
        COLOUR=$(${lib.getExe pkgs.yq} -r .palette.base0$(cat ${osConfig.custom-stylix.randomColourPath}) ${osConfig.custom-stylix.theme})
        echo -e "Text colour: $COLOUR"
        cat ${config.home.homeDirectory}/.config/eww/eww.scss.template | sed "s/REPLACEME/$COLOUR/g" > ${config.home.homeDirectory}/.config/eww/eww.scss
        ${lib.getExe pkgs.eww} open-many --no-daemonize my_clock:primary my_clock:secondary --arg primary:monitor=DP-3 --arg secondary:monitor=HDMI-A-1
      ''}";
      ExecStop = "${pkgs.writeShellScript "Stop EWW" ''
        ${lib.getExe pkgs.eww} close --no-daemonize
        rm ${config.home.homeDirectory}/.config/eww/eww.scss
      ''}";
    };
  };
  xdg.configFile."eww/eww.yuck".text = ''
    ;; Variables
    (defpoll time :interval "1s" "date '+%H:%M:%S'")
    (defpoll date :interval "1s" "date --iso-8601=seconds")

    (defvar show_date false)

    ;; Widget Definition
    (defwidget clock_widget []
      (eventbox
        :onhover "eww update show_date=true"
        :onhoverlost "eww update show_date=false"
        (box
          :class "container"
          :orientation "v"
          :space-evenly false
          :halign "center"

          (label :class "time" :text time)

          (revealer
            :transition "slidedown"
            :reveal show_date
            :duration "350ms"
            (label :class "date" :text date)))))

    ;; Window Configuration
    (defwindow my_clock [monitor]
      ;; 2. Bind monitor to the variable
      :monitor monitor
      :geometry (geometry
                  :x "10%"
                  :y "10%"
                  :width "30%"
                  :height "10px"
                  :anchor "top left")
      :stacking "bg"           ;; Keeps it below other windows
      :windowtype "desktop"    ;; Treats it as a desktop widget (wallpaper layer)
      :wm-ignore true
      (clock_widget))
  '';
  xdg.configFile."eww/eww.scss.template".text = ''
    * {
      all: unset;
      //font-family: "JetBrains Mono", "Roboto", serif;
      font-family: sans-serif
    }

    /* Text Shadow added for legibility against wallpapers */
    .time {
      font-size: 6rem;
      font-weight: 800;
      //color: #83A598;
      color: REPLACEME;
      //text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
    }

    .date {
      font-size: 1.5rem;
      font-weight: 600;
      //color: #83A598;
      color: REPLACEME;
      margin-top: 5px;
      //text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.8);
    }
  '';

}
