{lib, ...}: let
  inherit (lib) getExe;
in {
  perSystem = {config, ...}: {
    apps = {
      ooks-vim.program = getExe config.packages.ook-vim;
      default = config.apps.ook-vim;
    };
  };
}
