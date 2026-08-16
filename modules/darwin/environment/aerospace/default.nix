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
            # sketchybar reserves y_offset + height (28) from the screen, so
            # 0 here lands the window tops exactly on the bar bottom edge
            top = 0;
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
