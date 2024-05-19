{ lib, ... }:
{
  imports = [
    ./imv
  ];

  options.homeModules.desktop.media.image = {
    imv = {
      enable = lib.mkEnableOption "Enable imv image viewer";
    };
  };

}
