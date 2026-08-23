{ ... }:
let
in
{
  services = {
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          turbo = "auto";
          energy_performance_preference = "performance";
          energy_perf_bias = "performance";
          platform_profile = "performance";
          scaling_max_freq = 1600000;
        };
        battery = {
          battery_device = "BAT0";
          governor = "powersave";
          energy_performance_preference = "power";
          energy_perf_bias = "power";
          platform_profile = "low-power";
          turbo = "never";
          scaling_max_freq = 800000;
        };
      };
    };

    # Seems to conflict with cpu
    thermald = {
      enable = false;
    };
    upower.enable = true;
    tlp = {
      enable = true;
      pd.enable = true;
      settings = {
        # This is important to make sure tlp doesn't interfere with auto-cpufreq
        TLP_DISABLE_DEFAULTS = 1;

        TLP_PROFILE_AC = "PRF";
        TLP_PROFILE_BAT = "SAV";

        # Audio
        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # Battery thresholds
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;

        # Drive
        DISK_DEVICES = "nvme0n1";

        DISK_IOSCHED = "mq-deadine";

        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "auto";

        # File system
        DISK_IDLE_SECS_ON_AC = 0;
        DISK_IDLE_SECS_ON_BAT = 2;

        MAX_LOST_WORK_SECS_ON_AC = 15;
        MAX_LOST_WORK_SECS_ON_BAT = 60;

        # Graphics
        INTEL_GPU_POWER_PROFILE_ON_AC = "base";
        INTEL_GPU_POWER_PROFILE_ON_BAT = "base";
        INTEL_GPU_POWER_PROFILE_ON_SAV = "power_saving";

        # Kernel
        NMI_WATCHDOG = 0;

        # Networking
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        WOL_DISABLE = "Y";

        MEM_SLEEP_ON_AC = "s2idle";
        MEM_SLEEP_ON_BAT = "deep";

        # Radio Devices
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth nfc wwan";
        DEVICES_TO_ENABLE_ON_AC = "bluetooth nfc wifi";
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";

        # PCIe settings
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # USB suspend
        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_PHONE = 1;
      };
    };
  };
}
