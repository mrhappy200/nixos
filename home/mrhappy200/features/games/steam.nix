{
  pkgs,
  lib,
  config,
  ...
}: {
  ##
  # Since home manager does not use real bind mounts but uses FUSE instead, this does not work. A bind mount is set in hardware-configuration.nix
  ##
  #home.persistence = {
  #  "/persist/" = {
  #    allowOther = true;
  #    directories = [".local/share/Steam"];
  #  };
  #};

  # Steamtinkerlaunch is needed for Skyrim modding
  home.packages = [pkgs.steamtinkerlaunch];
  xdg.dataFile = {
    "Steam/compatibilitytools.d/SteamTinkerLaunch/compatibilitytool.vdf".text = ''
      "compatibilitytools"
      {
        "compat_tools"
        {
          "Proton-stl" // Internal name of this tool
          {
            "install_path" "."
            "display_name" "Steam Tinker Launch"

            "from_oslist"  "windows"
            "to_oslist"    "linux"
          }
        }
      }
    '';
    "Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch".source =
      config.lib.file.mkOutOfStoreSymlink "${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch";
    "Steam/compatibilitytools.d/SteamTinkerLaunch/toolmanifest.vdf".text = ''
      "manifest"
      {
        "commandline" "/steamtinkerlaunch run"
        "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
      }
    '';
  };
}
