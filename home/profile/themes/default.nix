{ lib, config, ... }:

# let
#   cfg = config.theme;
# in

{
  imports = [
    ./minimal
  ];

  options.theme = {
    minimal.enable = lib.mkEnableOption "enable minimal theme";
  };

  # config = {
  #   assertions = [
  #     {
  #       assertion = 
  #       (lib.length (lib.filter (x: x) [
  #         cfg.minimal or false
  #         cfg.OTHERTHEMEHERE or false
  #       ]) <= 1);
  #     }
  #   ];
  # };
}
