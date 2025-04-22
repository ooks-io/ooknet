{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.workstation) environment;
  padding = 16;
in {
  imports = [
    ./options.nix
    ./binds.nix
    ./rules.nix
  ];
  config = mkIf (environment == "aerospace") {
    services.aerospace = {
      enable = true;
      settings = {
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        accordion-padding = padding;
        gaps = {
          outer = {
            left = padding;
            right = padding;
            top = padding;
            bottom = padding;
          };
          inner = {
            horizontal = padding;
            vertical = padding;
          };
        };
      };
    };
  };
}
