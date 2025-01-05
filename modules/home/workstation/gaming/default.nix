{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  imports = [
    ./wow.nix
    ./wine.nix
    ./bottles.nix
    ./emulation.nix
  ];
  config = mkIf (elem "gaming" profiles) {
    ooknet.binds = {
      steam = "steam";
      factorio = "steam steam://rungameid/427520";
    };
  };
}
