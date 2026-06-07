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
      # graphical-session.target needs an explicit After, without it systemd injects an
      # implicit Before=graphical-session.target which loops back through
      # tray.target -> waybar -> graphical-session.target and breaks session startup
      After = ["graphical-session.target" "graphical-session-pre.target" "tray.target"];
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
