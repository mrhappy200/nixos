{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.hypridle = {
    enable = true;
    settings =
      let
        isLocked = "pgrep hyprlock";
        isDischarging = "grep Discharging /sys/class/power_supply/BAT{0,1}/status -q";
        brightnessSave = "${lib.getExe pkgs.ddcutil} -t --bus=11 getvcp 10 | awk '{ print $4}' > /tmp/savebrightness";
        brightnessRestore = "${lib.getExe pkgs.ddcutil} -t --bus=11 setvcp 10 $(cat /tmp/savebrightness)";
        brightnessSetRelative =
          percent:
          pkgs.writeShellScript "brightness-change-${toString percent}" ''
            # Add dependencies to path
            PATH="${pkgs.ddcutil}/bin:${pkgs.gawk}/bin:${pkgs.coreutils}/bin:$PATH"

            # 1. Get current status (VCP 10) in terse mode
            # Output format: VCP 10 C <current_value> <max_value>
            read -r _ _ _ CURRENT MAX < <(ddcutil getvcp 10 --terse)

            # 2. Calculate the delta based on the monitor's maximum brightness
            # We use integer math. If Max is 255, 10% is 25.
            DELTA=$(( MAX * ${toString percent} / 100 ))

            # 3. Calculate target
            TARGET=$(( CURRENT + DELTA ))

            # 4. Clamp target to valid range (0 to MAX)
            if (( TARGET > MAX )); then TARGET=$MAX; fi
            if (( TARGET < 0 )); then TARGET=0; fi

            # 5. Apply new brightness
            ddcutil --bus=11 setvcp 10 $TARGET
          '';
      in
      {
        general = {
          lock_cmd = "if ! ${isLocked}; then ${lib.getExe config.programs.hyprlock.package}; fi";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          inhibit_sleep = 3; # Wait for lock before suspend
        };
        listener = [
          {
            timeout = 10;
            on-timeout = brightnessSave;
            on-resume = brightnessRestore;
          }
          {
            timeout = 20;
            on-timeout = "${(brightnessSetRelative (-50))}";
          }
          {
            timeout = 40;
            on-timeout = "${(brightnessSetRelative (-50))}";
          }
          {
            timeout = 60;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 90;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }

          # If already locked
          {
            timeout = 15;
            on-timeout = "if ${isLocked}; then ${brightnessSetRelative (-75)}; fi";
          }
          {
            timeout = 20;
            on-timeout = "if ${isLocked}; then hyprctl dispatch dpms off; fi";
            on-resume = "hyprctl dispatch dpms on";
          }

          # If discharging
          {
            timeout = 900;
            on-timeout = "if ${isDischarging}; then systemctl suspend; fi";
          }
        ];
      };
  };
}
