{ lib, ... }:

{
  imports = [ 
    ./indent.nix
    ./telescope.nix
    ./lualine.nix
  ];

  options.ooknet.console.editor.nvim.plugins = {
    indentBlankline = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable indent-blankline nvim plugin module";
    };
    lualine = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lualine nvim plugin module";
    };
    telescope = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable telescope nvim plugin module";
    };
  };
  
}
