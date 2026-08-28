{ inputs, ... }:
{
  imports = [ inputs.lan-mouse.homeManagerModules.default ];
  programs.lan-mouse = {
    enable = true;
    systemd = true;
    # Optional configuration in nix syntax, see config.toml for available options
    settings = {
      clients = [
        {
          position = "left";
          hostname = "happypc";
          ips = [ "192.168.1.29" ];
        }
        {
          position = "left";
          hostname = "thalia";
          ips = [ "192.168.1.121" ];
        }
      ];
    };
  };
}
