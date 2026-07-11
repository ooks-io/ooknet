{
  vim.filetree = {
    neo-tree = {
      enable = true;
      setupOpts = {
        filesystem = {
          hijack_netrw_behavior = "open_current";
          follow_current_file.enabled = true;
        };
      };
    };
  };
  vim.keymaps = [
    {
      key = "<C-e>";
      mode = "n";
      desc = "Toggle Tree";
      action = "<cmd>Neotree toggle reveal<cr>";
    }
  ];
}
