{ lib, config, ... }:

# let
#   cfg = config.theme;
# in

{
  imports = [
    ./minimal
    ./phone
  ];

  options.theme = {
    minimal.enable = lib.mkEnableOption "enable minimal theme";
    phone.enable = lib.mkEnableOption "Enable phone theme";
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
