{inputs, ...}: let
  inherit (inputs.nvf.lib) neovimConfiguration;

  mkNeovim = pkgs: modules:
    (neovimConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      inherit modules;
    })
    .neovim;
in
  mkNeovim
