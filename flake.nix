{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://nix-gaming.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # Nix ecosystem
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # The commit that broke everything was 17f6bd177404d6d43017595c5264756764444ab8
    nixpkgs.url = "github:NixOS/nixpkgs/7379d27cddb838c205119f9eede242810cd299a7";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    systems.url = "github:nix-systems/default-linux";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Third party programs, packaged with nix
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My own programs, packaged with nix
    themes = {
      url = "github:misterio77/themes";
      inputs.systems.follows = "systems";
    };
    hyprland.url = "github:hyprwm/Hyprland"; # follows development branch of hyprland
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
    };

    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell.url = "github:AvengeMedia/DankMaterialShell";
    # process monitor required for dank material shell
    dgop.url = "github:AvengeMedia/dgop";
    illogical-impulse.url = "github:xBLACKICEx/end-4-dots-hyprland-nixos";
    caelestia.url = "github:caelestia-dots/shell";
    caelestia-cli.url = "github:caelestia-dots/cli";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };
      hydraJobs = import ./hydra.nix { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      nixosConfigurations = {
        # Main desktop
        euphrosyne = lib.nixosSystem {
          modules = [ ./hosts/euphrosyne ];
          specialArgs = { inherit inputs outputs; };
        };
        # Personal laptop (TerraQue)
        HappyPC = lib.nixosSystem {
          modules = [ ./hosts/HappyPC ];
          specialArgs = { inherit inputs outputs; };
        };
        # Proxmox nix vm
        pve-nix-vm-1 = lib.nixosSystem {
          modules = [ ./hosts/pve-nix-vm-1 ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      # Standalone HM only
      homeConfigurations = {
        # chromebooks
        "mrhappy200@penguin" = lib.homeManagerConfiguration {
          modules = [
            ./home/mrhappy200/penguin.nix
            ./home/mrhappy200/nixpkgs.nix
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
