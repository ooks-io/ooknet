{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) getExe nameValuePair mkOption mkEnableOption elem assertMsg;
  inherit (builtins) attrValues;
  inherit (lib.types) int path port str;
  inherit (config.ooknet) server;
  inherit (config.virtualisation) podman;
  cfg = server.ookflix;
  ookflixEnabled = elem "ookflix" server.services;

  mkSubdomainOption = name: description: example:
    mkOption {
      type = str;
      default = "${name}.${server.domain}";
      inherit description example;
    };

  # check config.ids for static uid/gid based on service name, if available use that, if not, use fallback.
  # check fallback doesnt conflict with existing static id
  getId = idType: name: fallback: let
    allNixosIds = attrValues config.ids.${idType};
    fallbackConflict = elem fallback allNixosIds;
  in
    mkOption {
      type = int;
      default =
        config.ids.${idType}.${name}
        or (
          assert assertMsg (!fallbackConflict)
          "Fallback ${idType} ${toString fallback} for ${name} conflicts with NixOS static allocation"; fallback
        );
      description = "${idType} of ${name} container";
      example = 224;
    };

  mkUserOption = name: fallback: {
    name = mkOption {
      type = str;
      default = name;
      description = "Name of ${name} container user";
      example = "${name}";
    };
    id = getId "uids" name fallback;
  };

  mkGroupOption = name: fallback: {
    name = mkOption {
      type = str;
      default = name;
    };
    id = getId "gids" name fallback;
  };

  mkPortOption = value: description: example:
    mkOption {
      type = port;
      default = value;
      inherit description example;
    };

  mkVolumeOption = rootPath: pathValue:
    mkOption {
      type = path;
      default =
        if rootPath == "state"
        then "${cfg.volumes.state.root}/${pathValue}"
        else if rootPath == "data"
        then "${cfg.volumes.data.root}/${pathValue}"
        else if rootPath == "media"
        then "${cfg.volumes.media.root}/${pathValue}"
        else if rootPath == "torrents"
        then "${cfg.volumes.torrents.root}/${pathValue}"
        else if rootPath == "usenet"
        then "${cfg.volumes.usenet.root}/${pathValue}"
        else if rootPath == "usenet/complete"
        then "${cfg.volumes.usenet.complete.root}/${pathValue}"
        else if rootPath == "root"
        then pathValue
        else throw "Invalid VolumeOption rootPath: ${rootPath}. Must be one of 'state' 'data' 'media' 'torrents' 'usenet' 'usenet/complete' 'root'";
    };

  mkServiceOptions = name: {
    port,
    gid,
    uid,
    ...
  } @ args: {
    enable = mkEnableOption "Enable ${name} container" // {default = ookflixEnabled;};
    port = mkPortOption args.port "Port for ${name} container." 80;
    domain = mkSubdomainOption name "Domain for ${name} container." "${name}.mydomain.com";
    stateDir = mkVolumeOption "state" name;
    user = mkUserOption name args.uid;
    group = mkGroupOption name args.gid;
  };
  mkBasicServiceOptions = name: {
    gid,
    uid,
    ...
  } @ args: {
    enable = mkEnableOption "Enable ${name} container" // {default = ookflixEnabled;};
    user = mkUserOption name args.uid;
    group = mkGroupOption name args.gid;
  };
  mkServiceUser = service: {
    users.${service} = {
      isSystemUser = true;
      uid = cfg.services.${service}.user.id;
      name = service;
      group = service;
    };
    groups.${service} = {
      gid = cfg.services.${service}.group.id;
      name = service;
    };
  };
  mkServiceStateDir = service: {
    "${cfg.services.${service}.stateDir}"."d" = {
      mode = "0700";
      user = cfg.services.${service}.user.name;
      group = cfg.services.${service}.group.name;
    };
  };
  mkServiceStateFile = service: file: {
    "${cfg.services.${service}.stateDir}/${file}"."f" = {
      mode = "0600";
      user = cfg.services.${service}.user.name;
      group = cfg.services.${service}.group.name;
    };
  };

  mkServiceSecret = name: service: {
    ${name} = {
      file = "${self}/secrets/containers/${name}.age";
      owner = cfg.services.${service}.user.name;
      group = cfg.services.${service}.group.name;
    };
  };

  mkNetworkService = name: _network:
    nameValuePair "podman-network-${name}" {
      description = "Podman network ${name} for ookflix";
      serviceConfig = {
        Type = "oneshot";
        RemainsAfterExit = true;
        ExecStart = "${getExe podman.package} network create -d bridge ${name}";
        ExecStop = "${getExe podman.package} network rm -f ${name}";
      };
    };
in {
  inherit mkServiceStateFile mkServiceSecret mkBasicServiceOptions mkServiceOptions mkServiceStateDir mkServiceUser mkUserOption mkPortOption mkGroupOption mkVolumeOption mkSubdomainOption mkNetworkService;
}
