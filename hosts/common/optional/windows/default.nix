{
  config,
  pkgs,
  inputs,
  ...
}:

let
  winapps = inputs.winapps;
  toggle-windows = pkgs.writeShellScriptBin "toggle-windows" ''
    # Check the status of the docker-WinApps.service
    if systemctl is-active --quiet docker-WinApps.service; then
      systemctl stop docker-WinApps.service
      if [ $? -ne 0 ]; then
        notify-send "Error" "Failed to turn Windows off."
      else
          notify-send "Success" "Windows off"
      fi
    else
      systemctl start docker-WinApps.service
      if [ $? -ne 0 ]; then
        notify-send "Error" "Failed to turn Windows on."
      else
          notify-send "Success" "Windows on"
      fi
    fi
  '';
  username = "mrhappy200";
in

{

  imports = [
    ./windows.nix
  ];

  environment.systemPackages = [
    winapps.packages."${pkgs.system}".winapps
    winapps.packages."${pkgs.system}".winapps-launcher # optional
  ];

  home-manager.users.${username}.home = {
    file."/home/${username}/.config/winapps/winapps.conf".source = ./winapps.conf;

    packages = with pkgs; [
      toggle-windows
    ];
  };

}
