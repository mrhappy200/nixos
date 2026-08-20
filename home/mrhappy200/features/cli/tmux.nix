{
  config,
  pkgs,
  lib,
  ...
}:
let
  tmuxBin = "${pkgs.tmux}/bin/tmux";
  resurrectDir = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";

  killEmptySessionsSh = pkgs.writeShellScript "tmux-kill-empty-sessions" ''
    sessions=$(${tmuxBin} list-sessions -F '#{session_name}:#{session_attached}' 2>/dev/null) || exit 0
    for entry in $sessions; do
      name=''${entry%%:*}
      attached=''${entry##*:}
      [ "$attached" = "0" ] || continue
      all_shell=true
      for cmd in $(${tmuxBin} list-panes -t "$name" -F '#{pane_current_command}' 2>/dev/null); do
        case "$cmd" in
          bash|zsh|fish|sh|dash) ;;
          *) all_shell=false; break ;;
        esac
      done
      $all_shell && ${tmuxBin} kill-session -t "$name"
    done
  '';

  renameSessionSh = pkgs.writeShellScript "tmux-rename-session" ''
    session="$1"
    base="$2"
    name="$base"
    n=1

    # All session names except the current one
    others=$(${tmuxBin} list-sessions -F '#{session_name}' 2>/dev/null \
      | grep -vxF "$session")

    # Increment suffix until the name is unique among other sessions
    while echo "$others" | grep -qxF "$name"; do
      n=$((n + 1))
      name="$base ($n)"
    done

    ${tmuxBin} rename-session -t "$session" "$name"
  '';

  autoAttachSh = ''
    if [ -z "$TMUX" ]; then
      exec tmux new-session
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-b";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      # Seamless <C-hjkl> navigation across tmux panes and vim/nvim splits.
      # Requires the matching vim plugin on the editor side.
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g status off
      set -g exit-empty off
      # set-hook -g pane-focus-in 'rename-session "#{pane_current_command}"'
      set-hook -g pane-focus-in 'run-shell "${renameSessionSh} #{session_name} #{pane_current_command}"'
      set-hook -g after-client-detached 'run-shell "${killEmptySessionsSh}"'

      # ── Vi mode ────────────────────────────────────────────────────────────
      set -g mode-keys vi
      set -g status-keys vi

      # ── Splits: | / - mirror vim's vertical/horizontal split feel ──────────
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # ── Pane navigation: prefix + hjkl (fallback when not in vim) ──────────
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # ── Pane resize: prefix + HJKL (repeatable) ────────────────────────────
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # ── Copy mode: v to select, C-v to toggle block, y to yank ────────────
      bind-key -T copy-mode-vi v   send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

      # Enter copy mode with prefix+Escape (mirrors vim muscle memory)
      bind Escape copy-mode
    '';
  };

  #programs.bash.initExtra = autoAttachSh;
  #programs.zsh.initExtra = autoAttachSh;
  #programs.fish.interactiveShellInit = ''
  #  if not set -q TMUX
  #    exec tmux new-session
  #  end
  #'';

  systemd.user.services.tmux-server = {
    Unit = {
      Description = "tmux server";
      After = [ "default.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${tmuxBin} start-server";
      ExecStop = "${tmuxBin} kill-server";
      Restart = "on-failure";
      RestartSec = "2s";
      OOMScoreAdjust = -500;
      MemoryHigh = "512M";
      MemoryMax = "1G";
      CPUQuota = "40%";
    };
  };

  systemd.user.services.tmux-save = {
    Unit = {
      Description = "Save tmux sessions";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${resurrectDir}/scripts/save.sh";
      Environment = [ "TMUX_RESURRECT_DIR=%h/.local/share/tmux/resurrect" ];
    };
  };

  systemd.user.timers.tmux-save = {
    Unit = {
      Description = "Periodic tmux session save";
    };
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.startServices = "sd-switch";

  home.persistence."/persist" = {
    directories = [ ".local/share/tmux" ];
  };
}
#{
#  config,
#  pkgs,
#  lib,
#  ...
#}:
#let
#  tmuxBin = "${pkgs.tmux}/bin/tmux";
#  resurrectDir = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
#
#  # Kills any unattached session whose every pane is just a shell.
#  killEmptySessionsSh = pkgs.writeShellScript "tmux-kill-empty-sessions" ''
#    sessions=$(${tmuxBin} list-sessions -F '#{session_name}:#{session_attached}' 2>/dev/null) || exit 0
#    for entry in $sessions; do
#      name=''${entry%%:*}
#      attached=''${entry##*:}
#      [ "$attached" = "0" ] || continue
#      all_shell=true
#      for cmd in $(${tmuxBin} list-panes -t "$name" -F '#{pane_current_command}' 2>/dev/null); do
#        case "$cmd" in
#          bash|zsh|fish|sh|dash) ;;
#          *) all_shell=false; break ;;
#        esac
#      done
#      $all_shell && ${tmuxBin} kill-session -t "$name"
#    done
#  '';
#
#  autoAttachSh = ''
#    if [ -z "$TMUX" ]; then
#      exec tmux new-session
#    fi
#  '';
#in
#{
#  programs.tmux = {
#    enable = true;
#    prefix = "C-b";
#    mouse = true;
#    plugins = with pkgs.tmuxPlugins; [
#      sensible
#      {
#        plugin = resurrect;
#        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
#      }
#    ];
#    extraConfig = ''
#      set -g status off
#      set -g exit-empty off
#      set-hook -g pane-focus-in 'rename-session "#{pane_current_command}"'
#      set-hook -g client-detached 'run-shell "${killEmptySessionsSh}"'
#    '';
#  };
#
#  programs.bash.initExtra = autoAttachSh;
#  programs.zsh.initExtra = autoAttachSh;
#  programs.fish.interactiveShellInit = ''
#    if not set -q TMUX
#      exec tmux new-session
#    end
#  '';
#
#  systemd.user.services.tmux-server = {
#    Unit = {
#      Description = "tmux server";
#      After = [ "default.target" ];
#    };
#    Install = {
#      WantedBy = [ "default.target" ];
#    };
#    Service = {
#      Type = "forking";
#      ExecStart = "${tmuxBin} start-server";
#      ExecStop = "${tmuxBin} kill-server";
#      Restart = "on-failure";
#      RestartSec = "2s";
#      OOMScoreAdjust = -500;
#      MemoryHigh = "512M";
#      MemoryMax = "1G";
#      CPUQuota = "40%";
#    };
#  };
#
#  systemd.user.services.tmux-save = {
#    Unit = {
#      Description = "Save tmux sessions";
#    };
#    Service = {
#      Type = "oneshot";
#      ExecStart = "${pkgs.bash}/bin/bash ${resurrectDir}/scripts/save.sh";
#      Environment = [ "TMUX_RESURRECT_DIR=%h/.local/share/tmux/resurrect" ];
#    };
#  };
#
#  systemd.user.timers.tmux-save = {
#    Unit = {
#      Description = "Periodic tmux session save";
#    };
#    Timer = {
#      OnBootSec = "5min";
#      OnUnitActiveSec = "5min";
#    };
#    Install = {
#      WantedBy = [ "timers.target" ];
#    };
#  };
#
#  systemd.user.startServices = "sd-switch";
#
#  home.persistence."/persist" = {
#    directories = [ ".local/share/tmux" ];
#  };
#}
##{
##  config,
##  pkgs,
##  lib,
##  ...
##}:
##
##let
##  tmuxBin = "${pkgs.tmux}/bin/tmux";
##  resurrectDir = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
##
##  # Each terminal spawns its own session.
##  # If the terminal crashes, the session stays alive in the server.
##  # Recover with: tmux ls  then  tmux attach -t <id>
##  autoAttachSh = ''
##    if [ -z "$TMUX" ]; then
##      exec tmux new-session
##    fi
##  '';
##in
##{
##  programs.tmux = {
##    enable = true;
##    prefix = "C-b";
##    mouse = true;
##    plugins = with pkgs.tmuxPlugins; [
##      sensible
##      {
##        plugin = resurrect;
##        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
##      }
##    ];
##    extraConfig = ''
##      set -g status off
##      set -g exit-empty off
##      set-hook -g pane-focus-in 'rename-session "#{pane_current_command}"'
##    '';
##  };
##
##  programs.bash.initExtra = autoAttachSh;
##  programs.zsh.initExtra = autoAttachSh;
##  programs.fish.interactiveShellInit = ''
##    if not set -q TMUX
##      exec tmux new-session
##    end
##  '';
##
##  # Keeps the server alive even when all terminals are closed,
##  # so sessions are never lost between terminal opens.
##  systemd.user.services.tmux-server = {
##    Unit = {
##      Description = "tmux server";
##      After = [ "default.target" ];
##    };
##    Install = {
##      WantedBy = [ "default.target" ];
##    };
##    Service = {
##      Type = "forking";
##      ExecStart = "${tmuxBin} start-server";
##      ExecStop = "${tmuxBin} kill-server";
##      Restart = "on-failure";
##      RestartSec = "2s";
##      OOMScoreAdjust = -500;
##      MemoryHigh = "512M";
##      MemoryMax = "1G";
##      CPUQuota = "40%";
##    };
##  };
##
##  # Saves session layout to disk every 5 minutes (survives full reboots).
##  systemd.user.services.tmux-save = {
##    Unit = {
##      Description = "Save tmux sessions";
##    };
##    Service = {
##      Type = "oneshot";
##      ExecStart = "${pkgs.bash}/bin/bash ${resurrectDir}/scripts/save.sh";
##      Environment = [ "TMUX_RESURRECT_DIR=%h/.local/share/tmux/resurrect" ];
##    };
##  };
##
##  systemd.user.timers.tmux-save = {
##    Unit = {
##      Description = "Periodic tmux session save";
##    };
##    Timer = {
##      OnBootSec = "5min";
##      OnUnitActiveSec = "5min";
##    };
##    Install = {
##      WantedBy = [ "timers.target" ];
##    };
##  };
##
##  systemd.user.startServices = "sd-switch";
##
##  home.persistence."/persist" = {
##    directories = [ ".local/share/tmux" ];
##  };
##}
