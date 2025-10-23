{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum;
in {
  options.ooknet.console = {
    profile = mkOption {
      type = nullOr (enum ["standard" "minimal"]);
      default = "standard";
    };
    editor = mkOption {
      type = enum ["nvim"];
      default = "nvim";
    };
    multiplexer = mkOption {
      type = enum ["zellij"];
      default = "zellij";
    };
    shell = {
      bash.enable = mkEnableOption "";
      zsh.enable = mkEnableOption "";
      fish.enable = mkEnableOption "";
    };
    tools = {
      codex.enable = mkEnableOption "";
      bat.enable = mkEnableOption "";
      btop.enable = mkEnableOption "";
      direnv.enable = mkEnableOption "";
      eza.enable = mkEnableOption "";
      ffmpeg.enable = mkEnableOption "";
      fzf.enable = mkEnableOption "";
      nixIndex.enable = mkEnableOption "";
      starship.enable = mkEnableOption "";
      utils.enable = mkEnableOption "";
      git.enable = mkEnableOption "";
      ssh.enable = mkEnableOption "";
      zellij.enable = mkEnableOption "";
      nvim.enable = mkEnableOption "";
      ooknet-infra.enable = mkEnableOption "";
    };
  };
}
