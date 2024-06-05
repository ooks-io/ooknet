{ lib, config, pkgs, ... }:
let
  inherit (config.colorscheme) palette;
  inherit (lib) mkIf;
  cfg = config.ooknet.multiplexer.zellij;
  console = config.ooknet.console;
in

{
  config = mkIf (cfg.enable || console.multiplexer == "zellij") {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "${config.colorscheme.slug}";
        default_shell = "fish";
        default_layout = "default";
        pane_frames = false;
        themes = {
          "${config.colorscheme.slug}" = {
            fg = "#${palette.base05}";
            bg = "#${palette.base00}";
            black = "#${palette.base00}";
            red = "#${palette.base08}";
            green = "#${palette.base0B}";
            yellow = "#${palette.base0A}";
            blue = "#${palette.base0D}";
            magenta = "#${palette.base0E}";
            cyan = "#${palette.base0C}";
            white = "#${palette.base05}";
            orange = "#${palette.base09}";
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

