
export DRIVE=nvme1n1
export BOOT_PARTITION="${DRIVE}p1"
export ROOT_PARTITION="${DRIVE}p2"

printf "label: gpt\n,550M,U\n,,L\n" | sfdisk /dev/$DRIVE

mkfs.vfat -n BOOT -F32 /dev/$BOOT_PARTITION
parted /dev/$BOOT_PARTITION set 1 boot on

zpool create -o autotrim=on -O compression=zstd -O acltype=posixacl -O xattr=sa -O atime=off -O mountpoint=legacy zroot $ROOT_PARTITION

zfs create -o encryption=on -o keyformat=passphrase zroot/locker
zfs create zroot/locker/home
zfs create zroot/locker/nix
zfs create zroot/locker/os



mkdir -p /mnt/{home,boot,nix}


mount -t zfs zroot/locker/os /mnt
mount -t zfs zroot/locker/home /mnt/home
mount -t zfs zroot/locker/nix /mnt/nix
mount /dev/$BOOT_PARTITION /mnt/boot


nixos-generate-config --root /mnt
