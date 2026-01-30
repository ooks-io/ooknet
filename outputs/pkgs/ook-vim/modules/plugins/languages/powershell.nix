{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) attrNames;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.types) enum listOf;
  inherit (lib.nvim.types) mkGrammarOption;
  inherit (lib.nvim.attrsets) mapListToAttrs;

  cfg = config.vim.languages.powershell;

  defaultServers = ["powershell-editor-services"];
  servers = {
    powershell-editor-services = {
      enable = true;
      cmd = ["${pkgs.powershell-editor-services}/bin/PowerShellEditorServices"];
      filetypes = ["ps1" "psm1" "psd1"];
      root_markers = [".git"];
    };
  };
in {
  options.vim.languages.powershell = {
    enable = mkEnableOption "PowerShell language support";
    treesitter = {
      enable = mkEnableOption "PowerShell Treesitter support" // {default = config.vim.languages.enableTreesitter;};
      package = mkGrammarOption pkgs "powershell";
    };

    lsp = {
      enable = mkEnableOption "PowerShell LSP support" // {default = config.vim.lsp.enable;};
      servers = mkOption {
        type = listOf (enum (attrNames servers));
        default = defaultServers;
        description = "PowerShell LSP server to use";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })

    (mkIf cfg.enable (mkMerge [
      (mkIf cfg.lsp.enable {
        vim.lsp.servers =
          mapListToAttrs (n: {
            name = n;
            value = servers.${n};
          })
          cfg.lsp.servers;
      })
    ]))
  ];
}
