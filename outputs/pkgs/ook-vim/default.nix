{
  inputs,
  pkgs,
  ...
}: let
  ooks-vim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit inputs;};
    modules = [
      ./config
      ./modules
    ];
  };
in
  ooks-vim.neovim
