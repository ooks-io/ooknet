{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf boolToString;
  inherit (lib.types) bool enum lines nullOr str submodule attrsOf;
  inherit (lib.nvim.dag) entryBefore;
  inherit (lib.nvim.lua) toLuaObject;

  # hack to get around nvf's handling of prefixed @ in toLuaObject
  wrapHighlights = highlights:
    lib.mapAttrs' (
      name: value:
        if lib.hasPrefix "@" name
        then lib.nameValuePair "hl_${name}" value
        else lib.nameValuePair name value
    )
    highlights;

  highlightOpts = submodule {
    options = {
      # https://neovim.io/doc/user/api.html#nvim_set_hl()
      fg = mkOption {
        type = nullOr str;
        default = null;
        description = "Foreground color";
      };
      bg = mkOption {
        type = nullOr str;
        default = null;
        description = "Background color";
      };
      sp = mkOption {
        type = nullOr str;
        default = null;
        description = "SP color";
      };
      blend = mkOption {
        type = nullOr bool;
        default = null;
        description = "Blend attribute";
      };
      bold = mkOption {
        type = nullOr bool;
        default = null;
        description = "Italic attribute";
      };
      standout = mkOption {
        type = nullOr bool;
        default = null;
        description = "Standout attribute";
      };
      underline = mkOption {
        type = nullOr bool;
        default = null;
        description = "underline attribute";
      };
      undercurl = mkOption {
        type = nullOr bool;
        default = null;
        description = "Undercurl attribute";
      };
      underdouble = mkOption {
        type = nullOr bool;
        default = null;
        description = "Underdouble attribute";
      };
      underdotted = mkOption {
        type = nullOr bool;
        default = null;
        description = "Underdotted attribute";
      };
      underdashed = mkOption {
        type = nullOr bool;
        default = null;
        description = "Underdashed attribute";
      };
      strikethrough = mkOption {
        type = nullOr bool;
        default = null;
        description = "Strikethrough attribute";
      };
      italic = mkOption {
        type = nullOr bool;
        default = null;
        description = "Bold attribute";
      };
      reverse = mkOption {
        type = nullOr bool;
        default = null;
        description = "Reverse attribute";
      };
      nocombine = mkOption {
        type = nullOr bool;
        default = null;
        description = "Nocombine attribute";
      };
      link = mkOption {
        type = nullOr str;
        default = null;
        description = "Link attribute";
      };
    };
  };

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
    additionalHighlights = mkOption {
      type = attrsOf highlightOpts;
      default = {};
      description = "Additional highlight groups to be applied after theme setup.";
    };
  };

  config = mkIf cfg.enable {
    vim = {
      startPlugins = [pkgs.vimPlugins.gruvbox-material-nvim];
      luaConfigRC.theme =
        entryBefore ["pluginConfigs" "lazyConfigs"]
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
              force_background = ${boolToString cfg.signsHighlight},
            },
          }

          local extra_highlights = ${toLuaObject (wrapHighlights cfg.additionalHighlights)}
          for group_name, settings in pairs(extra_highlights) do
            -- Unwrap our prefixed names back to @ form
            local actual_name = group_name:gsub("^hl_@", "@")
            vim.api.nvim_set_hl(0, actual_name, settings)
          end

        '';
    };
  };
}
