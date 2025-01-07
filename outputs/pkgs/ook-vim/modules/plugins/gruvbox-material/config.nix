{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf boolToString;
  inherit (lib.types) bool enum lines;
  inherit (lib.nvim.dag) entryAfter;

  cfg = config.vim.gruvbox-material;
in {
  options.vim.gruvbox-material = {
    enable = mkOption {
      type = bool;
      description = "Enable gruvbox-material-theme";
      default = false;
    };
    contrast = mkOption {
      type = enum ["dark" "medium" "soft"];
      description = "Set contrast, can be any of 'hard', 'medium', 'soft'";
      default = "dark";
    };
    italics = mkOption {
      type = bool;
      description = "Enable italic comments";
      default = true;
    };
    transparent = mkOption {
      type = bool;
      description = "Set background to transparent";
      default = false;
    };
    floatForceBackground = mkOption {
      type = bool;
      description = "Force backgrounds on floats even when transparent = true";
      default = false;
    };
    signsHighlight = mkOption {
      type = bool;
      description = "Enable sign highlighting";
      default = true;
    };
    extraConfig = mkOption {
      type = lines;
      description = "Additional lua configuration after";
    };
  };

  config = mkIf cfg.enable {
    vim = {
      startPlugins = [pkgs.vimPlugins.gruvbox-material-nvim];
      luaConfigRC.theme =
        entryAfter ["basic"]
        /*
        lua
        */
        ''
          require('gruvbox-material').setup{
            contrast = "${cfg.contrast}",
            comments = {
              italics = ${boolToString cfg.italics},
            },
            background = {
              transparent = ${boolToString cfg.transparent},
            },
            float = {
              force_background = ${boolToString cfg.floatForceBackground},
              background_color = nil,
            },
            signs = {
              highlight = ${boolToString cfg.signsHighlight},
            },
          }
          ${cfg.extraConfig}
        '';
    };
  };
}
