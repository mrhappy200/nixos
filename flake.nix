{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astronvim = { url = "github:AstroNvim/AstroNvim"; flake = false; };
    astronvim-user = { url = "github:mrhappy200/nvim"; flake = false; };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        HappyPC = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/HappyPC/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
          ];
        };
      };
    };
}
