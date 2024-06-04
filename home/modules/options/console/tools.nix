{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.tools = {
    btop.enable = mkEnableOption "";
    eza.enable = mkEnableOption "";
    bat.enable = mkEnableOption "";
    direnv.enable = mkEnableOption "";
    fzf.enable = mkEnableOption "";
    git.enable = mkEnableOption "";
    ssh.enable = mkEnableOption "";
    nixIndex.enable = mkEnableOption "";
    starship.enable = mkEnableOption "";
    utils.enable = mkEnableOption "";
  };
}
