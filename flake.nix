{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

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
    # schizofox = {
    #   url = "github:schizofox/schizofox";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    systems.url = "github:nix-systems/default-linux";
    # hyprland "ecosystem"
    
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
  
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";


    ooks-scripts = {
      url = "github:ooks-io/scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus.url = "github:dj95/zjstatus";

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };


  outputs = { self, nixpkgs, home-manager, nix-on-droid, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;

      hm = inputs.home-manager.nixosModules.home-manager;
    in
    {
      inherit lib;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: {
        live-buds-cli = pkgs.callPackage ./pkgs/live-buds-cli { };
      });

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        # T480s
        ookst480s =  lib.nixosSystem {
          modules = [ 
            ./system/hosts/ookst480s 
            hm
          ];
          specialArgs = { inherit inputs outputs self; };
        };
        # Main Desktop
        ooksdesk =  lib.nixosSystem {
          modules = [ 
            ./system/hosts/ooksdesk
            hm
          ];
          specialArgs = { inherit inputs outputs self; };
        };
        # GPD Micro-PC
        ooksmicro =  lib.nixosSystem {
          modules = [ ./system/hosts/ooksmicro ];
          specialArgs = { inherit inputs outputs; };
        };
        # Media Server/Alternative desktop
        ooksmedia =  lib.nixosSystem {
          modules = [ ./system/hosts/ooksmedia ];
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
        # GPD Micro-PC
        "ooks@ooksmicro" = lib.homeManagerConfiguration {
          modules = [ ./home/user/ooks/ooksmicro ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
        # Media Server/Alternative desktop
        "ooks@ooksmedia" = lib.homeManagerConfiguration {
          modules = [ ./home/user/ooks/ooksmedia ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
    };
    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [ ./system/hosts/ooksphone ];
      pkgs = import nixpkgs {
        system = "aarch64-linux";
      };
      system = "aarch64-linux";
      extraSpecialArgs = { inherit inputs outputs; };
    };
  };
}
