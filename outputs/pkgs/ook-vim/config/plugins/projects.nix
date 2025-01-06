{
  vim.projects = {
    project-nvim = {
      enable = true;
      setupOpts = {
        manualMode = false;
        detectionMethods = ["lsp" "pattern"];
        patterns = [
          ".git"
          "index.*"
          "flake.nix"
        ];
      };
    };
  };
}
