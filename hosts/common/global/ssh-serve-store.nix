{config, ...}: {
  nix = {
    sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUOBbcoej+j4lo2P2QTtBgTvufqA8ccXWM6sW8tgWws root@HappyChromebook"
      ];
      protocol = "ssh";
      write = true;
    };
    settings.trusted-users = ["nix-ssh"];
  };
}
