{ lib, ... }:
{
  imports = [
    ./nixIndex
    ./git
    ./tools
    ./ssh
  ];

  options.homeModules.console.utility = {
    nixIndex = {
      enable = lib.mkEnableOption "Enable nixIndex configuration";
    };
    git = {
      enable = lib.mkEnableOption "Enable git + tools";
    };
    ssh = {
      enable = lib.mkEnableOption "Enable various console ssh";
    };
    tools = {
      enable = lib.mkEnableOption "Enable various console tools";
    };
  };
}
