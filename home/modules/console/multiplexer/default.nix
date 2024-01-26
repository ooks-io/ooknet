{ lib, config, ... }:
{
  imports = [
    ./zellij
    #./screen
    #./tmux
  ];

  options.homeModules.console.multiplexer = {
    zellij = {
      enable = lib.mkEnableOption "Enable zellij multiplexer";
    };
  };
}
