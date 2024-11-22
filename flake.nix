{
  description = "My NixOS configuration";
  nixConfig = {
    extra-substituters =
      [ "https://nix-community.cachix.org" "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #    nixpkgs.url = "github:nixos/nixpkgs/27e30d177e57d912d614c88c622dcfdb2e6e6515";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    stylix.url = "github:danth/stylix";

    firefox.url = "github:nix-community/flake-firefox-nightly";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ShyFox = {
      url = "github:Naezr/shyFox?ref=4.0-alpha";
      flake = false;
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    myNvim.url = "github:mrhappy200/nvim";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, lanzaboote, nixos-generators
    , disko, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });
    in {
      inherit lib;
      homeManagerModules = import ./modules/home-manager;
      # templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };
      # hydraJobs = import ./hydra.nix { inherit inputs outputs; };

      templates = {
        full = {
          path = ./.;
          description =
            "My nix config, copy if you wish (you probably shouldn't want to though)";
        };
      } // import ./templates;
      defaultTemplate = self.templates.full;

      packages = forEachSystem (pkgs: (import ./pkgs { inherit pkgs; }));

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      nixosModules = import ./modules/nixos // {
        myFormats = { config, ... }: {
          imports = [ nixos-generators.nixosModules.all-formats ];

          nixpkgs.hostPlatform = "aarch64-linux";
          nixpkgs.buildPlatform = { system = "x86_64-linux"; };

          # customize an existing format
          formatConfigs.vmware = { config, ... }: {
            services.openssh.enable = true;
          };
        };
      };
      nixosConfigurations = {
        # Main desktop
        HappyPC = lib.nixosSystem {
          modules = [
            stylix.nixosModules.stylix
            lanzaboote.nixosModules.lanzaboote
            ./hosts/HappyPC
          ];
          specialArgs = { inherit inputs outputs; };
        };
        HappyChromebook = lib.nixosSystem {
          modules = [
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            ./hosts/HappyChromebook
          ];
          specialArgs = { inherit inputs outputs; };
        };
        HappyRaspi = lib.nixosSystem {
          modules = [
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            ./hosts/HappyRaspi
            self.nixosModules.myFormats
          ];
          specialArgs = { inherit inputs outputs; };
        };
      };
      homeConfigurations = {
        # Desktops
        "mrhappy200@HappyPC" = lib.homeManagerConfiguration {
          modules = [ ./home/mrhappy200/HappyPC.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "mrhappy200@HappyRaspi" = lib.homeManagerConfiguration {
          modules = [ ./home/mrhappy200/HappyRaspi.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        "mrhappy200@HappyChromebook" = lib.homeManagerConfiguration {
          modules = [ ./home/mrhappy200/HappyChromebook.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
