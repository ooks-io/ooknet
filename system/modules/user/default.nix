{ lib, ... }:

{
  imports = [
    ./shell
    ./ooks.nix
  ];

  options.systemModules.user = {
    ooks = {
      enable = lib.mkEnableOption "Enable the user ooks";
    };
  };  
}
