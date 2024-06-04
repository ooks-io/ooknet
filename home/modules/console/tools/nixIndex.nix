{ lib, config, inputs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.nixIndex;
in

{
  imports = [ inputs.nix-index-db.hmModules.nix-index ];
  config = mkIf cfg.enable {
    programs = {
      nix-index = {
        enable = true;
        symlinkToCacheHome = true;
      };
      command-not-found.enable = false;
      nix-index-database.comma.enable = true;
    };
    home.sessionVariables.NIX_AUTO_RUN = "1";
  };
}
