{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://yazi.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # The commit that broke everything was 17f6bd177404d6d43017595c5264756764444ab8
    #nixpkgs.url = "github:NixOS/nixpkgs/7379d27cddb838c205119f9eede242810cd299a7";
    # This used to be .05
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    systems.url = "github:nix-systems/default-linux";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    hardware.url = "github:nixos/nixos-hardware";
    tuwunel.url = "github:matrix-construct/tuwunel";
    impermanence.url = "github:nix-community/impermanence";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:/nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lan-mouse.url = "github:feschber/lan-mouse";
    nix-colors.url = "github:misterio77/nix-colors";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hppynvim = {
      url = "github:mrhappy200/nvim";
    };
    hppyemacs = {
      url = "github:mrhappy200/emacs";
    };
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

    guacamole-oidc-extension = {
      url = "https://apache.org/dyn/closer.lua/guacamole/1.6.0/binary/guacamole-auth-sso-1.6.0.tar.gz?action=download";
      flake = false;
    };

    f3d-preview-yazi = {
      url = "github:ruudjhuu/f3d-preview.yazi";
      flake = false;
    };

    ## TODO: Couldn't be arsed to do this (guacamole extensions) with flakes.
    #guacamole-psql-extension = {
    #  url = "https://dlcdn.apache.org/guacamole/1.6.0/binary/guacamole-auth-jdbc-1.6.0.tar.gz";
    #  flake = false;
    #};

    #guacamole-psql-driver = {
    #  url = "https://jdbc.postgresql.org/download/postgresql-1.6.0.jar";
    #  flake = false;
    #};

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
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      determinate,
      nixpkgs-xr,
      nix-flatpak,
      nixflix,
      winapps,
      stylix,
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
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit inputs pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      nixosConfigurations = {
        # Main desktop
        euphrosyne = lib.nixosSystem {
          modules = [
            ./hosts/euphrosyne
            nixpkgs-xr.nixosModules.nixpkgs-xr
            nixflix.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            determinate.nixosModules.default
          ];
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
