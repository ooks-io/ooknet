{lib, ...}: let
  inherit (lib) recursiveUpdate;
  mkGraphicalService = recursiveUpdate {
    Unit = {
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  inherit mkGraphicalService;
}
