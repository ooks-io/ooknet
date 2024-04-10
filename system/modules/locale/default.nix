{ lib, config, ... }: 

let
  cfg = config.systemModules.locale;
in

{
  config = lib.mkIf cfg.enable {
    i18n = {
      defaultLocale = lib.mkDefault "en_US.UTF-8";
      supportedLocales = lib.mkDefault [
        "en_US.UTF-8/UTF-8"
      ];
    };
    time.timeZone = lib.mkDefault "Pacific/Auckland";
    location.provider = "geoclue2";
    services.geoclue2.enable = true;
  };
}
