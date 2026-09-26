{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mapAttrs optionalAttrs;
  inherit (builtins) elem;
  inherit (config.ooknet.hardware) features;

  networks = {
    home-1 = {
      var = "HOME_1";
      priority = 20;
    };
    home-2 = {
      var = "HOME_2";
      priority = 10;
    };
    phone = {
      var = "PHONE";
      priority = 1;
      metered = true;
      # hotspot is wpa3 only
      keyMgmt = "sae";
    };
  };

  mkProfile = id: {
    var,
    priority,
    metered ? false,
    # wpa-psk = wpa2 (and wpa2/wpa3 transition), sae = wpa3 only
    keyMgmt ? "wpa-psk",
  }: {
    connection =
      {
        inherit id;
        type = "wifi";
        autoconnect-priority = priority;
      }
      # nm keyfile enum, 1 = yes
      // optionalAttrs metered {metered = 1;};
    wifi = {
      mode = "infrastructure";
      ssid = "$" + var + "_SSID";
    };
    wifi-security = {
      key-mgmt = keyMgmt;
      psk = "$" + var + "_PSK";
    };
    ipv4.method = "auto";
    ipv6.method = "auto";
  };
in {
  config = mkIf (elem "wifi" features) {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [config.age.secrets.wifi.path];
      profiles = mapAttrs mkProfile networks;
    };
  };
}
