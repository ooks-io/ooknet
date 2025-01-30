{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.workstation.programs.ollama;
in {
  config = mkIf cfg.enable {
    # FIXME:
    # https://github.com/NixOS/nixpkgs/issues/376930
    services.ollama = {
      enable = false;
      acceleration = "rocm";
      rocmOverrideGfx = "10.1.0";
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1010";
      };
    };
  };
}
