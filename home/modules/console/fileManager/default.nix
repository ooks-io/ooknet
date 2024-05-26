{ lib, ... }:

{

  imports = [
    ./lf #configuration still needs some work
    # ./ranger
  ];

  options.homeModules.console.fileManager = {
    lf = {
      enable = lib.mkEnableOption "Enable lf file manager";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set lf as the default terminal file manager";
      };
    };
    ranger = {
      enable = lib.mkEnableOption "Enable ranger file manager";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set ranger as the default terminal file manager";
      };
    };
  };
}
