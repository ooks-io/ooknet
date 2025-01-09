{
  inputs,
  pkgs,
  hozen,
  ...
}: let
  ooks-vim = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit inputs hozen;};
    modules = [
      ./config
      ./modules
    ];
  };
in
  ooks-vim.neovim
