{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet) host;
in {
  config = mkIf (host.admin.name == "ooks" && host.type == "vm" && host.role == "server") {
    ooknet = {
      console = {
        editor = "nvim";
        multiplexer = "zellij";
      };
    };
  };
}
