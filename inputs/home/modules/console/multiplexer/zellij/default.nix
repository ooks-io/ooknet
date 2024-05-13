{ lib, config, pkgs, ... }:
let
  inherit (config) colorscheme;
  inherit (colorscheme) colors;
  cfg = config.homeModules.console.multiplexer.zellij;
in

{
  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "${colorscheme.slug}";
        default_shell = "fish";
        default_layout = "default";
        pane_frames = false;
        themes = {
          "${colorscheme.slug}" = {
            fg = "#${colors.base05}";
            bg = "#${colors.base00}";
            black = "#${colors.base00}";
            red = "#${colors.base08}";
            green = "#${colors.base0B}";
            yellow = "#${colors.base0A}";
            blue = "#${colors.base0D}";
            magenta = "#${colors.base0E}";
            cyan = "#${colors.base0C}";
            white = "#${colors.base05}";
            orange = "#${colors.base09}";
          };
        };
      };
    };

    # Layouts
    # Default layout
    xdg.configFile."zellij/layouts/default.kdl" = import ./layouts/defaultLayout.nix { inherit pkgs config; };
    # Layout for bash scripts
    xdg.configFile."zellij/layouts/script.kdl" = import ./layouts/scriptLayout.nix { inherit pkgs config; };
    # Layout for configuring my flake
    xdg.configFile."zellij/layouts/flake.kdl" = import ./layouts/flakeLayout.nix { inherit pkgs config; };

    # Additional keybinds
    xdg.configFile."zellij/config.kdl".text = /* kdl */ ''
      keybinds {
          shared_except "locked" {
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
          }
      }
    '';
  };
}

