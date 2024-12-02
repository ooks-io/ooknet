{lib, ...}: let
  inherit (builtins) isBool;
  inherit (lib) toUpper optionalAttrs mapAttrs' nameValuePair;

  # convert homepage attributes to labels
  mkHomepageLabels = {
    name,
    domain,
    group,
    widget ? {},
    ...
  } @ args: let
    # common homepage labels
    commonLabels = mapAttrs' (n: v: nameValuePair "homepage.${n}" (toString v)) {
      inherit name group;
      icon = "${name}.svg";
      href = domain;
      description = args.description or name;
    };

    # process widget attributes, flattening them into label format
    processWidget = attrs:
      mapAttrs' (n: v:
        nameValuePair "homepage.widget.${n}" (
          if isBool v
          then
            if v
            then "true"
            else "false"
          else toString v
        ))
      attrs;
  in
    commonLabels // (processWidget widget);

  mkContainerLabel = {name, ...} @ args: let
    homepage = args.homepage or {};
    baseWidget = homepage.widget or {};
  in
    # traefik router labels
    (optionalAttrs (args ? domain) {
      "traefik.enable" = "true";
      "traefik.http.routers.${name}.rule" = "Host(`${args.domain}`)";
      "traefik.http.routers.${name}.entrypoints" = "websecure";
      "traefik.http.routers.${name}.tls" = "true";
      "traefik.http.routes.${name}.certresolver" = "cloudflare";
    })
    # traefik service labels
    // (optionalAttrs ((args ? domain) && (args ? port)) {
      "traefik.http.services.${name}.loadbalancer.server.port" = toString args.port;
    })
    # homepage labels
    // (optionalAttrs (args ? homepage) (mkHomepageLabels {
      inherit name;
      domain = "https://${args.domain}";
      group = args.homepage.group or name;
      widget =
        baseWidget
        // {
          type = name;
          url = "https://${args.domain}";
          key = "{{HOMEPAGE_FILE_${toUpper name}}}";
        };
    }));

  mkContainerEnvironment = user: group: {
    PUID = toString user;
    PGID = toString group;
    # TODO: I dont want to hard code this
    TZ = "Antarctica/Macquarie";
  };

  mkContainerPort = port: "${toString port}:${toString port}";
in {
  inherit mkContainerLabel mkContainerEnvironment mkContainerPort;
}
