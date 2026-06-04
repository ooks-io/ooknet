
```
 ██████╗  ██████╗ ██╗  ██╗███╗   ██╗███████╗████████╗
██╔═══██╗██╔═══██╗██║ ██╔╝████╗  ██║██╔════╝╚══██╔══╝
██║   ██║██║   ██║█████╔╝ ██╔██╗ ██║█████╗     ██║   
██║   ██║██║   ██║██╔═██╗ ██║╚██╗██║██╔══╝     ██║   
╚██████╔╝╚██████╔╝██║  ██╗██║ ╚████║███████╗   ██║   
 ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝ .org
```

<p align= center>A monorepo for all my nix expressions powered by flake-parts.</p>

## Overview

The goals of this repository are:

1. To maintain a centralized location for all my personal computing
   infrastructure
2. To provide a place to experiment and learn about networking, administration,
   security, unix, design, and programming

> [!WARNING]
> This repository isn't intended to be used by anyone but myself. It's highly
> personalized and likely doesn't fit anyone else's needs. I maintain this
> repository publicly as a reference for anyone building something similar.

## Features

- NixOS configurations for all my hosts
- Home-Manager configuration for my workstations
- Custom packages
- Development environments
- Declarative secrets with agenix
- Personal website
- Templates for bootstrapping projects

## Fleet

Below are all the hosts I currently maintain within this flake:

| host        | spec                                  | role        | description                       | architecture   | status |
| ----------- | ------------------------------------- | ----------- | --------------------------------- | -------------- | ------ |
| ooksdesk    | 7500F / RX5700XT / 32 GB DDR5         | Workstation | Primary desktop workstation       | x86_64         | UP     |
| ookst480s   | T480s / i5-8350U / 24 GB DDR4         | Workstation | Secondary mobile workstation      | x86_64         | UP     |
| ooksmicro   | GPD Micro PC / N8100 / 8 GB LPDR3     | Workstation | Pocket workstation                | x86_64         | UP     |
| ooksmedia   | i3-10100 / 1650 Super / 64 GB DDR4    | Server      | Homelab/Media server              | x86_64         | UP     |
| ooksx1      | X1 Carbon G4 / i5 6200U / 8 GB LPDDR3 | Workstation | Guest laptop                      | x86_64         | UP     |
| ooknode     | Linode Nanode                         | Server      | VPS for website                   | x86_64         | UP     |
| ookstest    | QEMU VM                               | Server      | Disposable test/sandbox server    | x86_64         | N/A    |
| ooksphone   | Termux                                | Workstation | Nix environment for android phone | aarch64        | DOWN   |
| ooksair     | M4 MBA                                | Workstation | Primary mobile workstation        | aarch64-darwin | UP     |
| ooksinstall | Live ISO                              | Installer   | Bootable installer image          | x86_64         | N/A    |

## Architecture

As this project serves as a learning environment, its architecture changes
frequently. While I'll try to keep this documentation current, what follows is a
high-level overview of the current design.

The current architecture enables straightforward bootstrapping of new hosts
while maintaining fine-grained configuration on a per-host basis. This is
accomplished using a roles and profiles pattern (similar to
[Puppet's roles and profiles method](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html)).

### Roles

- **Workstation**: Desktop/laptop systems with a GUI environment
- **Server**: Headless systems running specific services
- **Installer**: Bootable ISO images for provisioning new hosts

Hosts are declared as plain data under
`flake.ooknet.{workstations,servers,images}`. The builders in `outputs/builder/`
map that data with `mapAttrs` into `nixosConfigurations` /
`darwinConfigurations`, wiring up the right platform modules
([`lib.nixosSystem`](https://github.com/NixOS/nixpkgs/blob/master/flake.nix) for
linux, nix-darwin's `darwinSystem` for macos) and importing the matching host
module from `hosts/<hostname>`. The host attribute name is the hostname, so a
declaration only carries what makes the host unique while the builder absorbs the
boilerplate.

Workstations:

```nix
flake.ooknet.workstations = {
  ookst480s = {
    system = "x86_64-linux";
    type = "laptop";
  };
  ooksair = {
    system = "aarch64-darwin";
    type = "laptop";
  };
};
```

Servers:

```nix
flake.ooknet.servers = {
  ooknode = {
    system = "x86_64-linux";
    type = "vm";
    profile = "linode";
    domain = "ooknet.org";
    services = ["website" "forgejo"];
  };
};
```

Installer images:

```nix
flake.ooknet.images = {
  ooksinstall = {
    system = "x86_64-linux";
    type = "iso";
    role = "installer";
  };
};
```

### Profiles

Profiles are collections of related software and configuration that can be
enabled on a per-host basis. Some example workstation profiles:

- `gaming`: Steam & emulators
- `communication`: Discord, Teams, Matrix
- `productivity`: Document editing, note-taking
- `creative`: Art and design tools
- `media`: Audio/video playback and management
- `virtualization`: Virtual machine support
- `infra`: Infrastructure and ops tooling
- `work`: Work specific tooling

Example:

```nix
ooknet.workstation.profiles = ["gaming" "creative" "media"];
```

Servers pick a base `profile` (for VMs, e.g. `linode`) and a list of `services`
to run. Some example services:

- `website`: My static website
- `forgejo`: Git server
- `ookflix`: Media server services
- `monitoring`: Metrics and dashboards
- `authentik`: Identity provider

```nix
ooknet.server.services = ["ookflix" "monitoring"];
```

## Desktop environment

<img src=".github/assets/2025-01-26T21:52:48,481278761+11:00.png" />
All workstations use a minimal wayland configuration made from the following
components:

- **Compositor**: [Hyprland](https://github.com/hyprwm/Hyprland)
- **Utilities**:
  - **Idle**: [hypridle](https://github.com/hyprwm/hypridle)
  - **Screen locker**: [hyprlock](https://github.com/hyprwm/hyprlock)
  - **Wallpaper**: [hyprpaper](https://github.com/hyprwm/hyprpaper)
  - **Bar**: [Waybar](https://github.com/Alexays/Waybar)
  - **Notifications**: [Mako](https://github.com/emersion/mako)
- **Color Palette**:
  [Gruvbox extended](https://github.com/ooks-io/ooknet/blob/main/outputs/hozen/default.nix)

## Appreciation

I want to give some appreciation to the many people/resources who have helped in
some way to build this project.

### People

- [ghuntley](https://github.com/ghuntley)
- [NobbZ](https://github.com/NobbZ)
- [notashelf](https://github.com/NotAShelf)
- [mic92](https://github.com/Mic92)
- [fabaff](https://github.com/fabaff)
- [gerg-l](https://github.com/Gerg-L)
- [viperML](https://github.com/viperML)
- [colemickens](https://github.com/colemickens)
- [fufexan](https://github.com/fufexan)
- [max-privatevoid](https://github.com/max-privatevoid)

### Resources

- [nix.dev](https://nix.dev/)
- [noogle](https://noogle.dev/)
- [nix-pills](https://nixos.org/guides/nix-pills/)
