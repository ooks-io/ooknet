{ lib, ... }:
{

  imports = [
    ./helix
    ./nvim
  ];

  options.homeModules.console.editor = {
    helix = {
      enable = lib.mkEnableOption "Enable helix text editor";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set helix as the default text editor in environment variables";
      };
    };
    nvim = {
      enable = lib.mkEnableOption "Enable nvim text editor";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set nvim as the default text editor in environment variables";
      };
    };
  };
}
