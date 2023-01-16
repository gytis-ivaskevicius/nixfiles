export DRIVE=nvme1n1
export BOOT_PARTITION="${DRIVE}p1"
export ROOT_PARTITION="${DRIVE}p2"

printf "label: gpt\n,550M,U\n,,L\n" | sfdisk /dev/$DRIVE


mkfs.fat -F 32 /dev/$BOOT_PARTITION
mkfs.btrfs /dev/$ROOT_PARTITION

mkdir -p /mnt
mount /dev/$ROOT_PARTITION /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
umount /mnt


mount -o compress=zstd,subvol=root /dev/$ROOT_PARTITION /mnt
mkdir /mnt/{home,nix}
mount -o compress=zstd,subvol=home /dev/$ROOT_PARTITION /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/$ROOT_PARTITION /mnt/nix

mkdir /mnt/boot
mount /dev/$BOOT_PARTITION /mnt/boot


nixos-generate-config --root /mnt
