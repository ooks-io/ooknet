# forgejo for the hozen projects at git.hozen.dev, tailnet only. same shape as hozen-cdn: the dns record points
# at the tailscale address and the ookflix traefik terminates tls with the *.hozen.dev cert hozen-cdn requests
{
  config,
  lib,
  pkgs,
  ook,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
  inherit (config.ooknet.server.ookflix.services) traefik;

  domain = "git.hozen.dev";
  port = 3300;
  sshPort = 2222;

  theme = pkgs.writeText "theme-ooknet.css" (ook.lib.color.export.toForgejoTheme {scheme = ook.themes.dark;});

  route = (pkgs.formats.yaml {}).generate "hozen-forge-route.yml" {
    http = {
      routers.hozen-forge = {
        rule = "Host(`${domain}`)";
        entryPoints = ["websecure"];
        service = "hozen-forge";
      };
      services.hozen-forge.loadBalancer.servers = [
        {url = "http://host.containers.internal:${toString port}";}
      ];
    };
  };
in {
  config = mkIf (elem "hozen-forge" services) {
    assertions = [
      {
        assertion = elem "hozen-cdn" services && traefik.enable;
        message = "hozen-forge rides on the ookflix traefik and the *.hozen.dev cert set up by hozen-cdn";
      }
    ];

    services.forgejo = {
      enable = true;
      database = {
        type = "postgres";
        createDatabase = true;
      };
      settings = {
        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}/";
          HTTP_ADDR = "0.0.0.0";
          HTTP_PORT = port;
          LANDING_PAGE = "explore";
          START_SSH_SERVER = true;
          SSH_DOMAIN = domain;
          SSH_PORT = sshPort;
          SSH_LISTEN_PORT = sshPort;
        };
        service = {
          DISABLE_REGISTRATION = true;
          REQUIRE_SIGNIN_VIEW = true;
        };
        repository.DEFAULT_PRIVATE = "private";
        security.INSTALL_LOCK = true;
        ui = {
          THEMES = "forgejo-auto,forgejo-light,forgejo-dark,ooknet";
          DEFAULT_THEME = "ooknet";
        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
        };
      };
    };

    # ci for the hozen repos, on the host itself (label nixos): jobs run nix builds through the daemon. the
    # registration token is placed by hand: `forgejo-cli actions generate-runner-token` into
    # /var/lib/forgejo-runner/token as TOKEN=...
    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.hozen = {
        enable = true;
        name = "ooksmedia";
        url = "https://${domain}";
        tokenFile = "/var/lib/forgejo-runner/token";
        labels = ["nixos:host"];
        hostPackages = with pkgs; [bash coreutils curl gawk git gnused gnutar gzip nodejs config.nix.package];
        settings.runner.capacity = 1;
      };
    };

    # what hozen-mmo's ci needs and nix-gc must keep: the VS2005 toolchain (built from Microsoft's SDK iso) and
    # the retail Wow.exe, which is never fetched: `nix-store --add-fixed sha256 Wow.exe` once on this host
    system.extraDependencies = with inputs.hozen-mmo.packages.${pkgs.stdenv.hostPlatform.system}; [cl8 wow-exe];

    systemd.tmpfiles.rules = let
      fj = config.services.forgejo;
      css = "${fj.customDir}/public/assets/css";
    in [
      "d ${fj.customDir}/public 0750 ${fj.user} ${fj.group} - -"
      "d ${fj.customDir}/public/assets 0750 ${fj.user} ${fj.group} - -"
      "d ${css} 0750 ${fj.user} ${fj.group} - -"
      "L+ ${css}/theme-ooknet.css - - - - ${theme}"
    ];

    # web only through traefik on the podman bridge, git over ssh only on the tailnet
    networking.firewall = {
      extraInputRules = ''iifname "podman*" tcp dport ${toString port} accept'';
      interfaces.tailscale0.allowedTCPPorts = [sshPort];
    };

    virtualisation.oci-containers.containers.traefik = mkIf traefik.enable {
      volumes = ["${route}:/dynamic/hozen-forge.yml:ro"];
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "forgejo-cli" ''
        cd ${config.services.forgejo.stateDir}
        exec /run/wrappers/bin/sudo -u ${config.services.forgejo.user} -g ${config.services.forgejo.group} \
          env GITEA_WORK_DIR=${config.services.forgejo.stateDir} GITEA_CUSTOM=${config.services.forgejo.customDir} \
          ${lib.getExe config.services.forgejo.package} "$@"
      '')
    ];
  };
}
