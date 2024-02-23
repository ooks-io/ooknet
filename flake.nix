{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    nix-colors.url = "github:misterio77/nix-colors";

    ags.url = "github:Aylur/ags";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock.url = "github:hyprwm/hyprlock";
  
    hyprpaper.url = "github:hyprwm/hyprpaper";
  
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    ssbm-nix = {
      url = "github:djanatyn/ssbm-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus.url = "github:dj95/zjstatus";
    
  };


  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      inherit lib;

      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: {
        live-buds-cli = pkgs.callPackage ./pkgs/live-buds-cli { };
      });

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        # T480s
        ookst480s =  lib.nixosSystem {
          modules = [ ./system/hosts/ookst480s ];
          specialArgs = { inherit inputs outputs; };
        };
        # Main Desktop
        ooksdesk =  lib.nixosSystem {
          modules = [ ./system/hosts/ooksdesk ];
          specialArgs = { inherit inputs outputs; };
        };
        # GPD Micro-PC
        ooksmicro =  lib.nixosSystem {
          modules = [ ./system/hosts/ooksmicro ];
          specialArgs = { inherit inputs outputs; };
        };
      };
      homeConfigurations = {
        # T480s
        "ooks@ookst480s" = lib.homeManagerConfiguration {
          modules = [ ./home/user/ooks/ookst480s ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
        # Main Desktop
        "ooks@ooksdesk" = lib.homeManagerConfiguration {
          modules = [ ./home/user/ooks/ooksdesk ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
        # Main Desktop
        "ooks@ooksmicro" = lib.homeManagerConfiguration {
          modules = [ ./home/user/ooks/ooksmicro ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
