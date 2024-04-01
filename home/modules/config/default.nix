{ lib, ... }:

{
  imports = [
    ./fonts
    ./monitors
    ./wallpaper
    ./nix
    ./userDirs
    ./home
    ./nixColors
    ./mimeApps
  ];

  options.homeModules.config = {
    nix.enable = lib.mkEnableOption "enable nix configuration module";
    nixColors.enable = lib.mkEnableOption "enable nixColors configuration module";
    home.enable = lib.mkEnableOption "enable home configuration module";
    userDirs.enable = lib.mkEnableOption "enable userDirs configuration module";
    mimeApps.enable = lib.mkEnableOption "enable mimeApps configuration module";
  };
}
