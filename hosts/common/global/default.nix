# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
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
    config = {allowUnfree = true;};
  };

  hardware.enableRedistributableFirmware = true;
  networking.domain = "hppy200.dev";

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
