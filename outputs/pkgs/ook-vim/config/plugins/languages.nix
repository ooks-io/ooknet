{
  vim.languages = {
    astro = {
      enable = true;
      extraDiagnostics.enable = true;
      format = {
        enable = true;
      };
      lsp.enable = true;
      treesitter.enable = true;
    };

    svelte = {
      enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    markdown = {
      enable = true;
      vale.enable = false;
      ltex.enable = false;
      format.enable = true;
      extensions = {
        render-markdown-nvim = {
          enable = true;
          setupOpts = {
            heading = {
              width = "block";
              left_pad = 3;
              right_pad = 4;
            };
          };
        };
      };
    };

    typst = {
      enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        server = "tinymist";
      };
      format = {
        enable = true;
        type = "typstyle";
      };
      extensions.typst-preview-nvim = {
        enable = true;
      };
    };

    html = {
      enable = true;
      treesitter = {
        enable = true;
        autotagHtml = true;
      };
    };

    css = {
      enable = true;
      format.enable = true;
      treesitter.enable = true;
      lsp.enable = true;
    };

    bash = {
      enable = true;
      format.enable = true;
      extraDiagnostics.enable = true;
      treesitter.enable = true;
      lsp.enable = true;
    };

    lua = {
      enable = true;
      extraDiagnostics.enable = true;
      lsp = {
        enable = true;
        lazydev.enable = false;
      };
      treesitter.enable = true;
      format.enable = true;
    };

    nix = {
      enable = true;
      extraDiagnostics.enable = true;
      format = {
        enable = true;
        type = "alejandra";
      };
      lsp = {
        enable = true;
        server = "nil";
      };
      treesitter.enable = true;
    };

    ts = {
      enable = true;
      extraDiagnostics.enable = true;
      treesitter.enable = true;
      lsp.enable = true;
      format.enable = true;
      extensions = {
        ts-error-translator.enable = true;
      };
    };
    go = {
      enable = true;
      treesitter.enable = true;
      format.enable = true;
      lsp.enable = true;
      dap.enable = true;
    };
    yaml = {
      enable = true;
      treesitter.enable = true;
      lsp.enable = true;
    };
  };
}
