{ lib, config, inputs, ... }:

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  config = mkIf (host.type != "phone") {
    nixpkgs = {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1u"
          "electron-25.9.0"
        ];
      };
      overlays = [
        (final: prev: {
          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
        })
      ];
    };
  };
}
