{
  # ooknix
  description = "a nix configuration written by an orangutan";

  outputs = { flake-parts, nixpkgs, self, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./flake/pkgs
        ./flake/nixos.nix
      ];

      # flake = {
      #   nixosConfigurations = import ./flake/nixos.nix {inherit self inputs nixpkgs;};
      # };

    };

  # External inputs we depend on
  inputs = {
  ## TODO: 
  ## look into nix-super
  ## IMPLEMENT SECRETS YOU APE (agenix looks best)
  
    # unstable because why not
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:Nixos/nixpkgs/nixos-unstable-small";

    # contains more up-to-date wayland related packages. no need enabling atm
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # split your flake into... parts?
    flake-parts = {
      url = "github:hercules-ci/flake-parts"; 
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # dotfile configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    # nix shell environment on android
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # wrapper for nix rebuild
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix language server that berates me for my mistakes
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # colorschemes library
    nix-colors.url = "github:misterio77/nix-colors";


    # hyprland "ecosystem". hyprDE perhaps?
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprland-contrib.url = "github:hyprwm/contrib";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # helix because noun -> verb helps scratches my ape brain in the right spot
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # packaged firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zellij status bar
    zjstatus.url = "github:dj95/zjstatus";

    # media server module for hosting my legally purchased linux isos
    nixarr.url = "github:rasmus-kirk/nixarr";

    # personal scripts repo
    ooks-scripts.url = "github:ooks-io/scripts";
  };
}
