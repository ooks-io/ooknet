{config, ...}: let
  inherit (config.ooknet.appearance.fonts) monospace regular;
in {
  fonts.packages = [
    monospace.package
    regular.package
  ];
}
