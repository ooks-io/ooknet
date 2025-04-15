{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf;
in {
  time.timeZone = "Antarctica/Macquarie";
  i18n = mkIf isLinux {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };
}
