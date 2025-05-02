# Basic install

## Partitioning

Partitioning will depend on the drive you have, here is an example of a simple
partitioning scheme for a single drive.

```sh
# what drive we are using
export D="/dev/vda"
export D1=$D'1'
export D2=$D'2'

# size of the swap for example 1GiB swap would be:
export SWAP=1g
sudo parted -s $D mklabel gpt mkpart "EFI" fat32 1MiB 513MiB mkpart "NixOS" btrfs 513MiB 100% set 1 esp on
sudo mkfs.fat -F 32 $D1 && sudo mkfs.btrfs -f $D2

sudo mount $D2 -m /mnt

sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/swap

sudo umount /mnt

sudo mount -o subvol=root $D2 -m /mnt
sudo mount -o subvol=home $D2 -m /mnt/home
sudo mount -o subvol=nix $D2 -m /mnt/nix
sudo mount -o subvol=swap $D2 -m /mnt/swap
sudo mount $D1 -m /mnt/boot

sudo btrfs filesystem mkswapfilee --size $SWAP --uuid clear /mnt/swap/swapfile
```

## Installing Nix

```sh
sudo nixos-generate-conig --root /mnt
sudo nixos-install
# done
```
