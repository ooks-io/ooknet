{ config, lib, pkgs, ... }:

let
  cfg = config.systemModules.pipewire;
  inherit (lib) mkIf;
  inherit (lib.generators) toLua;
  inherit (lib.lists) optionals;
  hasBT = (builtins.elem "bluetooth" config.systemModules.hardware.features);
in

{
  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = !config.services.pipewire.enable;
    services.pipewire = 
    let
      quantum = 64;
      rate = 48000;
      qr = "${toString quantum}/${toString rate}";
    in
    {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # Low latency module provided by notashelf/nyx
      extraConfig.pipewire."99-lowlatency" = {
        context = {
          properties.default.clock.min-quantum = quantum;
          modules = [
            {
              name = "libpipewire-module-rtkit";
              flags = ["ifexists" "nofail"];
              args = {
                nice.level = -15;
                rt = {
                  prio = 88;
                  time.soft = 200000;
                  time.hard = 200000;
                };
              };
            }
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                server.address = ["unix:native"];
                pulse.min = {
                  req = qr;
                  quantum = qr;
                  frag = qr;
                };
              };
            }
          ];

          stream.properties = {
            node.latency = qr;
            resample.quality = 1;
          };
        };
      };

      wireplumber = {
        enable = true;
        configPackages = let
          matches = toLua {
            multiline = false;
            indent = false;
          } [[["node.name" "matches" "alsa_output.*"]]];

          apply_properties = toLua {} {
            "audio.format" = "S32LE";
            "audio.rate" = rate * 2;
            "api.alsa.period-size" = 2;
          };
        in
          [
            (pkgs.writeTextDir "share/lowlatency.lua.d/99-alsa-lowlatency.lua" ''
              alsa_monitor.rules = {
                {
                  matches = ${matches};
                  apply_properties = ${apply_properties};
                }
              }
            '')
          ]
          ++ optionals hasBT [
            (pkgs.writeTextDir "share/bluetooth.lua.d/51-bluez-config.lua" ''
              bluez_monitor.properties = {
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
              }
            '')
          ];
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
} 


