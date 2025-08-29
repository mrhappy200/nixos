# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./acme.nix
      #    ./auto-upgrade.nix
      ./fish.nix
      ./locale.nix
      ./nix.nix
      ./openssh.nix
      ./optin-persistence.nix
      ./podman.nix
      ./sops.nix
      #./ssh-serve-store.nix
      ./steam-hardware.nix
      ./systemd-initrd.nix
      ./swappiness.nix
      ./tailscale.nix
      ./tpm.nix
      ./gamemode.nix
      ./nix-ld.nix
      ./prometheus-node-exporter.nix
      ./kdeconnect.nix
      ./upower.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

   security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.u2f = {
    enable = true;
    settings = {
      interactive = true;
      cue = true;
      origin = "pam://yubi";
      authfile = pkgs.writeText "u2f-mappings" (
        lib.concatStrings [
          "mrhappy200"
          ":oUbv3TIjCep+Rkt3BKBRTps7z0DNlQ3ysDjWa2cFlaNVg2N9LmbAwiXYz1x+SQK5met8vmOjFqk5r1JuomlenQ==,KZ4Z8FyF6zM7N1qP03Ann9eauf8L6YLYN6Gn7z2BEpowf5GPRNkJ5LM0HVdDsib1b5Ef+JmbVEmMhGrKUgbkRw==,es256,+presence"
        ]
      );
    };
  };

  hardware.enableRedistributableFirmware = true;
  networking.domain = "hppy200.dev";

  environment.systemPackages = [pkgs.freetype pkgs.qt5.qtwayland];

  # Increase open file limit for sudoers
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
  ];

  systemd.extraConfig = "LimitNOFILE=1048576";

  # Cleanup stuff included by default
  services.speechd.enable = false;
}
