{
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str nullOr bool enum;
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.binds) mkMappingOption;
  inherit (lib.nvim.types) mkPluginSetupOption luaInline;
in {
  options.vim.notes.obsidianExtended = {
    enable = mkEnableOption "Complementary neovim plugin for Obsidian editor";
    setupOpts = mkPluginSetupOption "Obsidian.nvim" {
      dir = mkOption {
        type = str;
        default = "~/my-vault";
        description = "Location of Obsidian vault directory";
      };
      daily_notes = {
        folder = mkOption {
          type = nullOr str;
          default = null;
          description = "Directory in which daily notes should be created";
        };
        date_format = mkOption {
          type = nullOr str;
          default = null;
          description = "Date format used for creating daily notes";
        };
      };
      completion = {
        nvim_cmp = mkOption {
          # If using nvim-cmp, otherwise set to false
          type = bool;
          description = "If using nvim-cmp, otherwise set to false";
          default = config.vim.autocomplete.nvim-cmp.enable;
        };
      };
      new_notes_location = mkOption {
        type = nullOr (enum ["current_dir" "notes_subdir"]);
        default = null;
        description = ''
          Where to put new notes. Valid options are:
          * "current_dir" - put notes in same directory as current buffer
          * "notes_subdir" - put notes in the default notes subdirectory

          default option: "current_dir"
        '';
      };
      templates = {
        folder = mkOption {
          type = nullOr str;
          default = null;
          description = "Obsidian templates directory";
        };
        date_format = mkOption {
          type = nullOr str;
          default = null;
          description = "Date format used for templates";
        };
        time_format = mkOption {
          type = nullOr str;
          default = null;
          description = "Time format used for templates";
        };
      };
      preferred_link_style = mkOption {
        type = nullOr (enum ["wiki" "markdown"]);
        default = null;
        description = ''
          Either "wiki" or "markdown"
        '';
      };
      note_id_func = mkOption {
        type = nullOr luaInline;
        default =
          mkLuaInline
          # lua
          ''
            function(title)
              return title
            end
          '';
        description = ''
          Customize how a note ID is generated given an optional title
        '';
      };
      legacy_commands = mkOption {
        type = bool;
        default = false;
      };
      ui = {
        enable = mkOption {
          type = nullOr bool;
          default = null;
          description = ''
            Set to false to disable all additional syntax features
          '';
        };
        # TODO: add rest of ui options
      };
    };
    mappings = {
      openNote = mkMappingOption "Open note in obsidian" "<leader>oo";
      findNote = mkMappingOption "Open finder in obsidian vault" "<leader>of";
      newNote = mkMappingOption "Create new note" "<leader>on";
    };
  };
}
