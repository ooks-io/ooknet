{ lib, ... }:
{

  imports = [
    ./firefox
    # ./schizofox
    #./chrome -- still needs to be implemented
    #./brave -- still needs tio be implemented
  ];

  options.ooknet.desktop.browser = {
    firefox = {
      enable = lib.mkEnableOption "Enable firefox browser";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set Firefox as default browser";
      };
    };
    schizofox = {
      enable = lib.mkEnableOption "Enable schizofox browser";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set schizofox as default browser";
      };
    };
  };
}
