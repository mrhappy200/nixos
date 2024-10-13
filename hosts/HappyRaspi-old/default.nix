{
  pkgs,
  modulesPath,
  ...
}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  disabledModules = [
    "profiles/all-hardware.nix"
    "profiles/base.nix"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  imports = [
  ];

  programs.hyprland.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.hostPlatform = "aarch64-linux";
}
