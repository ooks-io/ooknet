{ lib, ... }: 

let
  inherit (lib) mkDefault;
in

{
  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
    supportedLocales = mkDefault [
      "en_US.UTF-8/UTF-8"
    ];
  };
  time.timeZone = mkDefault "Pacific/Auckland";
  location.provider = "geoclue2";
  services.geoclue2.enable = true;
}
