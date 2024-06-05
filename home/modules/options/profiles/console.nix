{ lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (types) nullOr enum;
in

{
  options.ooknet.console = {
    editor = mkOption {
      type = nullOr (enum ["helix" "nvim"]);
      default = "helix";
    };
    multiplexer = mkOption {
      type = nullOr (enum ["tmux" "zellij"]);
      default = null;
    };
    fileManager = mkOption {
      type = nullOr (enum ["yazi" "ranger" "lf"]);
      default = null;
    };
  };
}
