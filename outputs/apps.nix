{lib, ...}: let
  inherit (lib) getExe;
in {
  perSystem = {config, ...}: {
    apps = {
      ook-vim.program = getExe config.packages.ook-vim;
      default = config.apps.ook-vim;
    };
  };
}
