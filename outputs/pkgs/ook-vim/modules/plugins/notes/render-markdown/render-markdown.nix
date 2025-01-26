{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) str nullOr bool enum listOf int float attrsOf submodule either;
  inherit (lib.nvim.types) mkPluginSetupOption luaInline;

  # All possible Neovim modes
  neovimModes = [
    "n"
    "no"
    "nov"
    "noV"
    "noCTRL-v"
    "niI"
    "niR"
    "niV"
    "nt"
    "ntT"
    "v"
    "vs"
    "V"
    "Vs"
    "CTRL-V"
    "CTRL-Vs"
    "s"
    "S"
    "CTRL-S"
    "i"
    "ic"
    "ix"
    "R"
    "Rc"
    "Rx"
    "Rv"
    "Rvc"
    "Rvx"
    "c"
    "cr"
    "cv"
    "cvr"
    "r"
    "rm"
    "r?"
    "!"
    "t"
  ];

  # Preset options
  presetOptions = enum ["obsidian" "lazy" "none"];

  # Log level options
  logLevelOptions = enum ["error" "warn" "info" "debug" "trace"];

  # Anti-conceal ignore options submodule
  antiConcealIgnoreOptions = submodule {
    options = {
      head_icon = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where head icon anti-conceal behavior will be ignored";
      };
      head_background = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where head background anti-conceal behavior will be ignored";
      };
      head_border = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where head border anti-conceal behavior will be ignored";
      };
      code_language = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where code language anti-conceal behavior will be ignored";
      };
      code_background = mkOption {
        type = nullOr bool;
        default = true;
        description = "Whether to ignore code background anti-conceal behavior";
      };
      code_border = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where code border anti-conceal behavior will be ignored";
      };
      dash = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where dash anti-conceal behavior will be ignored";
      };
      bullet = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where bullet anti-conceal behavior will be ignored";
      };
      check_icon = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where check icon anti-conceal behavior will be ignored";
      };
      check_scope = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where check scope anti-conceal behavior will be ignored";
      };
      quote = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where quote anti-conceal behavior will be ignored";
      };
      table_border = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where table border anti-conceal behavior will be ignored";
      };
      callout = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where callout anti-conceal behavior will be ignored";
      };
      link = mkOption {
        type = nullOr (listOf (enum neovimModes));
        default = null;
        description = "Modes where link anti-conceal behavior will be ignored";
      };
      sign = mkOption {
        type = nullOr bool;
        default = true;
        description = "Whether to ignore sign anti-conceal behavior";
      };
    };
  };

  # Injection options submodule
  injectionOptions = submodule {
    options = {
      enabled = mkOption {
        type = nullOr bool;
        default = null;
        description = "Whether this injection is enabled";
      };
      query = mkOption {
        type = luaInline;
        description = "Treesitter query for the injection";
      };
    };
  };

  headingWidthType = enum ["block" "full"];

  headingPositionType = enum ["right" "inline" "overlay"];
in {
  options.vim.notes.render-markdown-nvim = {
    enable = mkEnableOption "Inline markdown rendering";
    setupOpts = mkPluginSetupOption "render-markdown" {
      enabled = mkOption {
        type = bool;
        default = true;
        description = "Whether Markdown should be rendered by default";
      };

      render_modes = mkOption {
        type = listOf (enum neovimModes);
        default = ["n" "c" "t"];
        description = ''
          Vim modes that will show a rendered view of the markdown file.
          Individual components can be enabled for other modes.
        '';
      };

      max_file_size = mkOption {
        type = float;
        default = 10.0;
        description = "Maximum file size (in MB) that this plugin will attempt to render";
      };

      debounce = mkOption {
        type = int;
        default = 100;
        description = "Milliseconds that must pass before updating marks";
      };

      preset = mkOption {
        type = presetOptions;
        default = "none";
        description = "Pre-configured settings to mimic various target user experiences";
      };

      log_level = mkOption {
        type = logLevelOptions;
        default = "error";
        description = "The level of logs to write to file";
      };

      log_runtime = mkOption {
        type = bool;
        default = false;
        description = "Print runtime of main update method";
      };

      file_types = mkOption {
        type = listOf str;
        default = ["markdown"];
        description = "Filetypes this plugin will run on";
      };

      injections = mkOption {
        type = attrsOf injectionOptions;
        default = {
          gitcommit = {
            enabled = true;
            query = ''
              ((message) @injection.content
                  (#set! injection.combined)
                  (#set! injection.include-children)
                  (#set! injection.language "markdown"))
            '';
          };
        };
        description = "Language injections for known filetypes";
      };

      anti_conceal = {
        enabled = mkOption {
          type = bool;
          default = true;
          description = "Enable hiding added text on the cursor line";
        };

        ignore = mkOption {
          type = antiConcealIgnoreOptions;
          default = {
            code_background = true;
            sign = true;
          };
          description = "Elements to always show, ignoring anti-conceal behavior";
        };

        above = mkOption {
          type = int;
          default = 0;
          description = "Number of lines above cursor to show";
        };

        below = mkOption {
          type = int;
          default = 0;
          description = "Number of lines below cursor to show";
        };
      };

      padding = {
        highlight = mkOption {
          type = str;
          default = "Normal";
          description = "Highlight to use when adding whitespace";
        };
      };

      on = {
        attach = mkOption {
          type = nullOr luaInline;
          default = null;
          description = "Called when plugin initially attaches to a buffer";
        };

        render = mkOption {
          type = nullOr luaInline;
          default = null;
          description = "Called after plugin renders a buffer";
        };
      };

      latex = {
        enabled = mkOption {
          type = nullOr bool;
          default = null;
          description = "Whether LaTeX should be rendered";
        };

        render_modes = mkOption {
          type = nullOr bool;
          default = null;
          description = "Additional modes to render LaTeX";
        };

        converter = mkOption {
          type = nullOr str;
          default = null;
          description = "Executable used to convert latex formula to rendered unicode";
        };

        highlight = mkOption {
          type = nullOr str;
          default = null;
          description = "Highlight for LaTeX blocks";
        };

        top_pad = mkOption {
          type = nullOr int;
          default = null;
          description = "Amount of empty lines above LaTeX blocks";
        };

        bottom_pad = mkOption {
          type = nullOr int;
          default = null;
          description = "Amount of empty lines below LaTeX blocks";
        };
      };

      heading = {
        enabled = mkOption {
          type = nullOr bool;
          default = null;
          description = "Enable heading icon & background rendering";
        };

        render_modes = mkOption {
          type = nullOr bool;
          default = null;
          description = "Additional modes to render headings";
        };

        sign = mkOption {
          type = nullOr bool;
          default = null;
          description = "Turn on/off sign column related rendering";
        };

        icons = mkOption {
          type = nullOr (listOf str);
          default = null;
          description = "Icons for different heading levels";
        };

        position = mkOption {
          type = nullOr headingPositionType;
          default = null;
          description = "How icons fill available space";
        };

        signs = mkOption {
          type = nullOr (listOf str);
          default = null;
          description = "Signs added to the sign column if enabled";
        };

        width = mkOption {
          type = nullOr (either headingWidthType (listOf headingWidthType));
          default = null;
          description = "Width of the heading background";
        };

        left_margin = mkOption {
          type = nullOr (either float (listOf float));
          default = null;
          description = "Margin to add to left of headings";
        };

        left_pad = mkOption {
          type = nullOr (either float (listOf float));
          default = null;
          description = "Padding to add to left of headings";
        };

        right_pad = mkOption {
          type = nullOr (either float (listOf float));
          default = null;
          description = "Padding to add to right of headings when width is 'block'";
        };

        min_width = mkOption {
          type = nullOr (either int (listOf int));
          default = null;
          description = "Minimum width for headings when width is 'block'";
        };

        border = mkOption {
          type = nullOr (either bool (listOf bool));
          default = null;
          description = "Add border above and below headings";
        };

        border_virtual = mkOption {
          type = nullOr bool;
          default = null;
          description = "Always use virtual lines for heading borders";
        };

        border_prefix = mkOption {
          type = nullOr bool;
          default = null;
          description = "Highlight border start using foreground highlight";
        };

        above = mkOption {
          type = nullOr str;
          default = null;
          description = "Character used above heading for border";
        };

        below = mkOption {
          type = nullOr str;
          default = null;
          description = "Character used below heading for border";
        };

        backgrounds = mkOption {
          type = nullOr (listOf str);
          default = null;
          description = "Highlights for heading backgrounds per level";
        };

        foregrounds = mkOption {
          type = nullOr (listOf str);
          default = null;
          description = "Highlights for heading and sign icons per level";
        };
      };
    };
  };
}
