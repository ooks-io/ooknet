{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr attrsOf submodule enum anything deferredModule listOf str;
  systemOptions = {
    additionalOptions ? {},
    example ? "",
    description ? "",
  }:
    mkOption {
      type = attrsOf (submodule {
        options =
          {
            system = mkOption {
              type = enum ["x86_64-linux" "aarch64-darwin"];
              description = "Systems architecture (e.g., x86_64-linux, aarch64-darwin)";
              example = "x86_64-linux";
            };
            additionalModules = mkOption {
              type = listOf deferredModule;
              default = [];
              description = ''
                Additional modules to include with the system
              '';
            };
            additionalArgs = mkOption {
              type = attrsOf anything;
              default = {};
              description = ''
                Additional special args to pass to the system
              '';
            };
          }
          // additionalOptions;
      });
      default = {};
      inherit example description;
    };
in {
  options.flake.ooknet = {
    workstations = systemOptions {
      additionalOptions = {
        type = mkOption {
          type = enum ["laptop" "desktop"];
          description = "Type of workstation (e.g., laptop, desktop)";
          example = "laptop";
        };
      };
    };
    servers = systemOptions {
      additionalOptions = {
        services = mkOption {
          type = listOf str;
          default = [];
          description = "List of services a server runs";
        };
        profile = mkOption {
          type = nullOr str;
          default = null;
        };
        domain = mkOption {
          type = str;
          default = "";
          description = "Servers domain name";
        };
        type = mkOption {
          type = enum ["desktop" "vm"];
          description = "Type of server (e.g., desktop, vm)";
          example = "vm";
        };
      };
    };
    images = systemOptions {
      additionalOptions = {
        profile = mkOption {
          type = nullOr str;
          default = null;
          description = "Profile to use instead of hostname-based config";
        };
        type = mkOption {
          type = enum ["iso"];
          description = "Image format type";
          example = "iso";
        };
        role = mkOption {
          type = enum ["installer" "live"];
          description = "Role of the image (installer or live)";
          example = "installer";
        };
      };
    };
  };
}
