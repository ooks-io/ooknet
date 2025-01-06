{
  inputs,
  pkgs,
  ...
}: let
  configuration = import ./config;
  ooks-vim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit inputs;};
    modules = [configuration];
  };
in
  ooks-vim.neovim
