{ lib, ... }:
{
  imports = [
    ./imv
  ];

  options.ooknet.desktop.media.image = {
    imv = {
      enable = lib.mkEnableOption "Enable imv image viewer";
    };
  };

}
