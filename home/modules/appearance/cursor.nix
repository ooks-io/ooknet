{ lib, config, ... }: 

let
  inherit (lib) mkIf;
  cfg = config.ooknet.cursor;
in

{
  config = mkIf cfg.enable {
    home.pointerCursor = {
      package = cfg.package;
      name = cfg.name;
      size = cfg.size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}

