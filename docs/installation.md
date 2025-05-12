# Installation and deployment

In this guide I will be going through a couple methods of installation and
deployment of an ooknet system.

## Manual install

**Assumptions**:

- We are starting fresh with no current installation of NixOS available
- We are already using a UNIX environment with access to the command: `lsblk`
  and `dd`

### Obtaining a NixOS installation media

#### Flashing a USB

> [!WARN]
> The following assumes you are already currently using an installation of
> linux, if not, alternative methods of usb flashing will be required.

If we intend to install onto a bare-metal machine the easiest method would be to
flash the image onto a USB to be used as the boot device. This can be done
easily via the `dd` command:

#### Determine USB `/dev/` path

Use the `lsblk` command to list out the current

```sh
$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:0    1  57.3G  0 disk  
├─sda1          8:1    1   1.1G  0 part  
└─sda2          8:2    1     3M  0 part  
nvme0n1       259:0    0 931.5G  0 disk  
├─nvme0n1p1   259:1    0   512M  0 part  /boot
└─nvme0n1p2   259:2    0   931G  0 part  
  └─cryptroot 254:0    0   931G  0 crypt /persist
```

Here we can see that `sda` is the intended target for our usb, so the full path
would be `/dev/sda`

#### Obtain install image

Download the
[Minimal NixOS Install Image](https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso).

#### Flash the USB

Run the following command to flash the USB with the installation image:

```sh
# Assuming the iso was downloaded to ~/Downloads/latest-nixos-minimal-x86-64-linux.iso
$ sudo dd bs=4M if=~/Downloads/latest-nixos-minimal-x86-64-linux.iso of=/dev/sda status=progress && sync
```

### Boot into install media

Using your host's BIOS (UEFI) boot manager, boot into the installation media.

### Disk partitioning

You will need to setup disk partitioning for the, how you partition a host is up
to you, in this example I will setup a basic btrfs setup:

Use `lsblk` to determine the target disk we want to partition

```sh
$ lsblk

NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:0    1  57.3G  0 disk  
├─sda1          8:1    1   1.1G  0 part  
└─sda2          8:2    1     3M  0 part  
nvme0n1       259:0    0 931.5G  0 disk
```

In this case we will be using `nvme0n1`

```sh
# if you would like to avoid using sudo repeatedly, you can opt to run sudo -i to login as root. In the following example I will opt not too use sudo -i

# here we are just settings up some optional environment variables to make the partitioning simpler 
$ export D="/dev/nvme0n1"
$ export P1=${D}p1
$ export P2=${D}p2
$ export SWAP=4g
```

Formatting and mounting

```sh
# partition drive
$ sudo parted \ 
-s $D mklabel gpt \ 
mkpart "EFI" fat32 1MiB 513MiB \ # boot partition
mkpart "NixOS" btrfs 513MiB 100% set 1 esp on # root partition

$ sudo mkfs.fat -F 32 $P1 && sudo mkfs.btrfs -f $P2 # define partition filesystem

# mount drives to create subvolumes
$ sudo mount $P2 -m /mnt

# define subvolumes
$ sudo btrfs subvolume create /mnt/{root,nix,home,swap}

$ sudo umount /mnt

# mount all subvolumes to there respective paths, making the directories if needed
$ sudo mount -o subvol={root,home,nix,swap} $P2 -m /mnt{,/home,/nix,/swap}

# mount boot
$ sudo mount $P1 -m /mnt/boot

# create swap file
$ sudo btrfs filesystem mkswapfile --size $SWAP --uuid clear /mnt/swap/swapfile
```

### Installing Nix

At this point if you would like to build the system directly from the ooknet
repository, you will need to obtain relevant ssh keys to decrypt the
configurations secrets. I recommend instead installing a minmal nixos
configuration, with a couple modifications. Then building from ooknet once
installed.

```sh
# generate hordware-configuration.nix
$ sudo nixos-generate-config --root /mnt
```

Using preferred text editor, add the following to
`/mnt/etc/nixos/configuration.nix`:

```nix
# setup "wheel" user
users.users.ooks = {
  isNormalUser = true;
  extraGroups = ["wheel" "video" "audio"];
};
# configure 1Password module, this will be used to obtain secrets to install the intended host configuration
programs = {
  _1password.enable = true;
  _1password-gui = {
    enable = true;
    polkitPolicyOwners = ["ooks"];
  };
};
```

You will also need some sort of graphical environment to boot into, I recommend
something simple like gnome

```nix
services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
};
# disable unnecessary gnome packages
environment.gnome.excludePackages = with pkgs; [
  orca
  epiphany
  evince
  gedit
  gnome-music
  gnome-photos
  gnome-terminal
  gnome-tour
  hitori
  iagno
  tali
  atomix
];
```

Install the system

```sh
$ sudo nixos-install
```

Set a password for the user

```sh
$ sudo nixos-enter --root /mnt -c 'passwd ooks'
```

Reboot the system

#### Post install

After booting into the fresh installation you will need to authenticate with
1Password and move the ssh keys required for secret decryption into ~/.ssh.

Following that, you can run:

`sudo nixos-rebuild --flake github:ooks-io/ooknet#<hostname>`

## Remote installation

In most circumstances, provisioning a new host will be done remotely. These are
the leverage a number of tools for remote provisioning:

- Disko
  - declarative disk partitioning/formatting)
- nixos-anywhere
  - script that manages, ssh connection, building/copying the system closure to
    remote host,and installing NixOS
- 1Password
  - for fetching keys required for decrypting secrets

### Pre-requisites

In order to provision a new host remotely a number of requirements must be met.

#### install-key

The install-key is the ssh key that is used as identity to ssh into the
ooknet-install-media as root. It can be obtained from the ooknet 1Password
vault.

#### Host disko configuration

The host's configuration entry point must import a valid disko configuration.

```nix
{
  imports = [
    ./disko.nix
  ];
}
```

An example disko configuration can be found
[here](../modules/nixos/server/profiles/ookstest/disko.nix).

#### Hardware.nix

The entry point must also import a `hardware.nix` file, later this will be
generated by nixos-anywhere.

```nix
{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];
}
```

#### Host keys

We must generate the targets host keys prior to deployment as we use them during
install to decrypt secrets. These host keys need to follow some rules:

- Stored in the ooknet 1Password vault
- tagged as "hostkey"
- Naming convention must be "\<hostname\>-hostkey"

Keys can be generated with `ssh-keygen` and manually added to 1Password, or most
simply generated, stored, and tagged via the 1Password cli:

```sh
$ op item create \
  --category=ssh \
  --title="hostname-hostkey" \
  --tags="hostkey" \
  --vault="ooknet"
```

See
[1Password Documentation](https://developer.1password.com/docs/ssh/manage-keys/).

#### Flake variable

The $FLAKE environment variable must be set to the root of the ooknet flake.

### Deploying system

To deploy the system run the `ooknet-provision` command with the following
options:

```
$ ooknet-provision <hostname> <target ip>
```

`ooknet-provision` has a couple optional flags to be aware of:

- -v, --verbose) Enable verbose output
- -d, --host-config-dir) Allow you to set the host configurations entry point,
  this will default to`$FLAKE/hosts/<hostname>`
- -o, --extra-options) Allows you to pass additional flags to the nixos-anywhere
  command

### ooknet-provision

The `ooknet-provision` script is just a thin wrapper around nixos-anywhere, it
runs a bunch of pre-deployment checks and handles the ssh host keys with
1Password.
