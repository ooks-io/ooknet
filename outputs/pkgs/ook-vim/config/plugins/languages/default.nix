{
  imports = [
    ./nix.nix
    ./lsp.nix
    ./bash.nix
    ./treesitter.nix
    ./html.nix
    ./ts.nix
    ./go.nix
    ./lua.nix
  ];

  vim.languages = {
    enableLSP = true;
    enableTreesitter = true;
    enableFormat = true;
    enableExtraDiagnostics = true;

    typst.enable = true;
  };
}
