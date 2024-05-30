{ lib, ... }:

{
  imports = [
    ./monitors
    ./nix
    ./userDirs
    ./home
    ./mimeApps
  ];

  options.ooknet.config = {
    nix.enable = lib.mkEnableOption "enable nix configuration module";
    home.enable = lib.mkEnableOption "enable home configuration module";
    userDirs.enable = lib.mkEnableOption "enable userDirs configuration module";
    mimeApps.enable = lib.mkEnableOption "enable mimeApps configuration module";
  };
}
