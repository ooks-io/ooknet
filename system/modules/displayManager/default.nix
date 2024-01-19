{ lib, ... }:

{
  imports = [
    ./tuigreet
  ];

  options.systemModules.displayManager = {
    tuigreet = {
      enable = lib.mkEnableOption "Enable tuigreet display manager module";
    };
  };
}
