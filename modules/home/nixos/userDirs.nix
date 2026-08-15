{config, ...}: {
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = let
      summit = "${config.home.homeDirectory}/Summit";
    in {
      enable = true;
      createDirectories = true;
      # keep exporting XDG_*_DIR session vars, fish functions + hyprcapture rely on them
      setSessionVariables = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${summit}/Documents";
      music = "${summit}/Media/Music";
      videos = "${summit}/Media/Videos";
      pictures = "${summit}/Media/Pictures";
      extraConfig = {
        SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
        CODE = "${summit}/code";
        RECORDINGS = "${config.xdg.userDirs.videos}/Recordings";
        NOTES = "${summit}/notes";
      };
    };
  };
}
