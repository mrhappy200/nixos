{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    disko
    sops
    ssh-to-age
    git
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.hyprland.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
