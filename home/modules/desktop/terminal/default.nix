{ lib, config, ... }:
  let
    cfg = config.homeModules.desktop.terminal;
  in
{

  imports = [
    ./foot
    ./kitty
  ];

  options.homeModules.desktop.terminal = {
    foot = {
      enable = lib.mkEnableOption "Enable foot terminal";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set foot as default terminal in environment variables";
      };
    };
    kitty = {
      enable = lib.mkEnableOption "Enable kitty terminal";
      default = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set kitty as default terminal in environment variables";
      };
    };
  };

   config = { 
    assertions = [
      {
        assertion = 
          (lib.length (lib.filter (x: x) [
            cfg.foot.default or false
            cfg.kitty.default or false
          ]) <= 1); 
        message = "Only one terminal can be default in the configuration";
      }
    ];
  };
}
