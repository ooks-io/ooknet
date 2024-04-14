{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./fish
    ./bash
    ./zsh
  ];

  options.systemModules.user.shell = mkOption {
    type = types.enum ["fish" "zsh" "bash"];
    default = "zsh";
    description = "The user shell to use. Select from 'zsh' 'bash' 'fish'";
  };
}
