{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr str bool attrsOf submodule;

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
in {
  options.vim.theme.custom = {
    enable = mkEnableOption "Enable custom theme";
    name = mkOption {
      type = str;
      default = "my-custom-theme";
      description = "Name of custom theme";
    };
    highlights = mkOption {
      type = attrsOf highlightOpts;
      default = {};
    };
  };
}
