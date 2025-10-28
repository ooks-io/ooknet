{lib, ...}: let
  inherit (lib) recursiveUpdate;
  mkGraphicalService = recursiveUpdate {
    Unit = {
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  mkTrayService = exec: {
    Unit = {
      Requires = ["tray.target"];
      After = ["graphical-session-pre.target" "tray.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = exec;
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };
in {
  inherit mkGraphicalService mkTrayService;
}
