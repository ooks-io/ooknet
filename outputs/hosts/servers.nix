{
  flake.ooknet.servers = {
    ooknode = {
      system = "x86_64-linux";
      type = "vm";
      profile = "linode";
      domain = "ooknet.org";
      services = ["website" "forgejo"];
    };
    ooksmedia = {
      system = "x86_64-linux";
      type = "desktop";
      domain = "ooknet.org";
      services = ["ookflix" "monitoring" "authentik" "searxng" "nixcache"];
    };
    bmo-001 = {
      system = "aarch64-linux";
      type = "sbc";
      domain = "ooknet.org";
      services = [];
    };
    ookstest = {
      system = "x86_64-linux";
      type = "vm";
      profile = "ookstest";
      domain = "ooknet.org";
      services = [];
    };
  };
}
