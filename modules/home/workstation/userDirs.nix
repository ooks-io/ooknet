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
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${summit}/Documents";
      music = "${summit}/Media/Music";
      videos = "${summit}/Media/Videos";
      pictures = "${summit}/Media/Pictures";
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        XDG_CODE_DIR = "${summit}/code";
        XDG_RECORDINGS_DIR = "${config.xdg.userDirs.videos}/Recordings";
        XDG_NOTES_DIR = "${summit}/notes";
      };
    };
  };
}
