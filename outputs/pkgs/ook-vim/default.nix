{
  inputs,
  pkgs,
  ook,
  ...
}: let
  ooks-vim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit inputs ook;};
    modules = [
      ./config
      ./modules
    ];
  };
in
  ooks-vim.neovim
