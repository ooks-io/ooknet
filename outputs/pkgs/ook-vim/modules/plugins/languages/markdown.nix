# modules/plugins/vale/default.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.types) package enum str;

  languages = [
    "auto"
    "ar"
    "ast-ES"
    "be-BY"
    "br-FR"
    "ca-ES"
    "ca-ES-valencia"
    "da-DK"
    "de"
    "de-AT"
    "de-CH"
    "de-DE"
    "de-DE-x-simple-language"
    "el-GR"
    "en"
    "en-AU"
    "en-CA"
    "en-GB"
    "en-NZ"
    "en-US"
    "en-ZA"
    "eo"
    "es"
    "es-AR"
    "fa"
    "fr"
    "ga-IE"
    "gl-ES"
    "it"
    "ja-JP"
    "km-KH"
    "nl"
    "nl-BE"
    "pl-PL"
    "pt"
    "pt-AO"
    "pt-BR"
    "pt-MZ"
    "pt-PT"
    "ro-RO"
    "ru-RU"
    "sk-SK"
    "sl-SI"
    "sv"
    "ta-IN"
    "tl-PH"
    "uk-UA"
    "zh-CN"
  ];

  cfg = config.vim.languages.markdown;
in {
  options.vim.languages.markdown = {
    vale = {
      enable = mkEnableOption "Vale linting support";
      package = mkOption {
        type = package;
        default = pkgs.vale.withStyles (styles: [
          styles.proselint
          styles.microsoft
          styles.write-good
          styles.readability
          styles.alex
        ]);
        description = "Vale package to use";
      };
    };
    ltex = {
      enable = mkEnableOption "Enable ltex-ls";
      package = mkOption {
        type = package;
        default = pkgs.ltex-ls-plus;
      };
      language = mkOption {
        type = enum languages;
        default = "en";
      };
      modelPath = mkOption {
        type = str;
        default = "~/.config/nvf/models/ngrams/";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.vale.enable {
      vim.lsp.null-ls = {
        enable = true;
        sources.vale-lint =
          # lua
          ''
            table.insert(
              ls_sources,
              null_ls.builtins.diagnostics.vale.with({
                command = "${cfg.vale.package}/bin/vale",
                diagnostics_format = "#{m} [#{c}]"
              })
            )
          '';
      };
    })
    (mkIf cfg.ltex.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.ltex-lsp =
        # lua
        ''
          lspconfig.ltex.setup{
            cmd = {"${cfg.ltex.package}/bin/ltex-ls-plus"},
            capabilities = capabilities;
            on_attach = default_on_attach;
            flags = { debounce_text_changes = 300 },
            settings = {
              ltex = {
                language = "${cfg.ltex.language}",
                additionalRules = {
                  languageModel = "${cfg.ltex.modelPath}",
                },
              },
            },
          }
        '';
    })
  ];
}
