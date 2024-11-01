{
  keys,
  config,
  ...
}: let
  inherit (config.ooknet.host) admin;
in {
  users = {
    groups.builder = {};
    users.builder = (key: ''command="nix-daemon --stdio",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding ${key}'') keys.users.${admin.name};
  };
}
