{
  description = "Description for the project";

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./outputs];
      systems = import inputs.systems;
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # zellij 0.44.x has a plugin render loop (zellij-org/zellij#5063, dj95/zjstatus#174)
    # pin 0.42.2 until fixed upstream
    nixpkgs-zellij.url = "github:NixOS/nixpkgs/7c43f080a7f28b2774f3b3f43234ca11661bf334";
    systems.url = "github:nix-systems/default";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/ooks-io/kunzen";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    # ookscraft = {
    #   url = "git+ssh://git@github.com/ooks-io/ookscraft";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-parts.follows = "flake-parts";
    #     nix-minecraft.follows = "nix-minecraft";
    #   };
    # };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixzeroth = {
      url = "git+file:///home/ooks/projects/nixzeroth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ooknet-monitor = {
      url = "git+file:///home/ooks/Summit/ookgen/ooknet-monitor";
      inputs = {
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.flake-utils.follows = "flake-utils";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        systems.follows = "systems";

        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
    };
  };
}
