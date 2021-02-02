
# My personal NixOS configuration
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

### File structure
1. `configurations` - Main system configuration. `base.nix` contains lots of useful defaults. `*.host.nix` files contain host specific configurations.
2. `home-manager` - Holds most of the desktop configuration. Obviously relies on `home-manager` flake.
3. `modules` - Represents `flake.nixosModules`.
4. `overlays` - Contains riced and custom packages. Riced packages have the name prefix `g-`.
5. `flake.nix` - Kickass flake config ;)
6. `repl.nix` - Kickass repl ;)


# ZFS Cheatsheet

## create pool with single drive
zpool create -o ashift=12 -o autotrim=on -O compression=zstd -O acltype=posixacl -O xattr=sa -O atime=off -O mountpoint=legacy zroot sdx2

## create pool with two mirrored drives
zpool create -o ashift=12 -o autotrim=on -O compression=zstd -O acltype=posixacl -O xattr=sa -O atime=off -O mountpoint=legacy zroot mirror sdx2 sdy2

## ^ autotrim should be omitted for non-SSD storage
## ^ ashift requires research. this setting is device-specific, and many drives will lie


zfs create -o encryption=on -o keyformat=passphrase zroot/locker
zfs create zroot/locker/home
zfs create zroot/locker/nix
zfs create zroot/locker/os


## esp partition
mkfs.vfat -n BOOT -F32 /dev/sdx1


mkdir /mnt/{home,boot,nix}
mount -t zfs zroot/locker/os /mnt
mount -t zfs zroot/locker/home /mnt/home
mount -t zfs zroot/locker/nix /mnt/nix
mount /dev/sdx1 /mnt/boot


networking.hostId = "12345678";  # needed for zfs. 4 random bytes (in hex)

## nixos documentation recommends setting these to false
boot = {
    zfs.forceImportAll = false;
    zfs.forceImportRoot = false;
};

## unmount and export all zfs stuff before leaving the live installer!
zfs export zroot
