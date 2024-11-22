# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, lib, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./auto-upgrade.nix
    ./avahi.nix
    ./fish.nix
    ./locale.nix
    ./sdr.nix
    ./nix-ld.nix
    ./nix.nix
    ./openssh.nix
    ./optin-persistence.nix
    ./sops.nix
    # ./ssh-serve-store.nix
    ./steam-hardware.nix
    ./tailscale.nix
    ./systemd-initrd.nix
    ./gamemode.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  environment.systemPackages = [ pkgs.lxqt.lxqt-policykit ];

  nixpkgs = {
    #hostPlatform = lib.mkForce "x86_64-linux";
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };

  # Fix for qt6 plugins
  # TODO: maybe upstream this?
  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = [ "/lib/qt-6/plugins" ];
  };

  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "65536";
    }
  ];
}
