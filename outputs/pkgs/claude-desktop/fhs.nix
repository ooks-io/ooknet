{
  buildFHSEnv,
  bubblewrap,
  claude-desktop,
  nodejs,
  docker,
  docker-compose,
  openssl,
  glibc,
  uv,
}:
buildFHSEnv {
  name = "claude-desktop";

  targetPkgs = pkgs: [
    bubblewrap
    claude-desktop
    docker
    docker-compose
    glibc
    nodejs
    openssl
    uv
  ];

  runScript = "${claude-desktop}/bin/claude-desktop";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${claude-desktop}/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons
    cp -r ${claude-desktop}/share/icons/* $out/share/icons/
  '';

  meta =
    claude-desktop.meta
    // {
      description = "Claude Desktop for Linux (FHS environment for MCP servers)";
    };
}
