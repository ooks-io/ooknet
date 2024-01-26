{ lib, ... }:
{
  imports = [
    ./nixIndex
    ./git
    ./tools
  ];

  options.homeModules.console.utility = {
    nixIndex = {
      enable = lib.mkEnableOption "Enable nixIndex configuration";
    };
    git = {
      enable = lib.mkEnableOption "Enable git + tools";
    };
    tools = {
      enable = lib.mkEnableOption "Enable various console tools";
    };
  };
}
