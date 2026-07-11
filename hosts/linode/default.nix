{
  imports = [
    ./image.nix
    ./base
  ];

  ooknet.server.forgejo = {
    customTheme.enable = true;
    hideLogo = true;
  };

  ooknet.server.webserver.caddy.cloudflareOnly = true;

  system.stateVersion = "24.11";
}
