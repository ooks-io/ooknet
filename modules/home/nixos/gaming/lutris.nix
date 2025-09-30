{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    programs.lutris = {
      enable = true;
      steamPackage = osConfig.programs.steam.package;
      defaultWinePackage = pkgs.proton-ge-bin;
      protonPackages = [pkgs.proton-ge-bin];
      winePackages = [
        pkgs.wineWow64Packages.full
        pkgs.wineWowPackages.stagingFull
      ];
      extraPackages = attrValues {
        inherit
          (pkgs)
          winetricks
          protontricks
          gamescope
          gamemode
          mangohud
          ;
      };
    };
  };
}
