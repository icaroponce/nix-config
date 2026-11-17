# Install

Fresh install of the `t450s` host from the NixOS minimal ISO.

| Part | Size | Type | Label | Content |
|---|---|---|---|---|
| p1 | 1G | EFI | `BOOT` | `/boot` (vfat) |
| p2 | 16G | LUKS2 | partlabel `cryptswap` | swap, hibernation |
| p3 | rest | LUKS2 | partlabel `cryptroot` | btrfs `nixos`: `@root` → `/`, `@home` → `/home`, `@nix` → `/nix` |

## 1. Prepare

- Write the **Minimal ISO, x86_64** from https://nixos.org/download to a USB stick
  (`dd if=nixos-minimal-*.iso of=/dev/<stick> bs=4M status=progress`).
- BIOS (F1): Secure Boot **disabled**, boot mode **UEFI only**.
- Boot the stick (F12), then `sudo -i`.
- Network: ethernet works as is; wifi with `nmtui`. Check with `ping -c3 nixos.org`.

## 2. Partition, encrypt, format

```sh
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN
DISK=/dev/sda                                   # the target disk, not the stick

sgdisk --zap-all $DISK
sgdisk -n1:0:+1G  -t1:ef00 -c1:BOOT      $DISK
sgdisk -n2:0:+16G -t2:8309 -c2:cryptswap $DISK
sgdisk -n3:0:0    -t3:8309 -c3:cryptroot $DISK
partprobe $DISK

mkfs.fat -F32 -n BOOT /dev/disk/by-partlabel/BOOT

# Same passphrase for both: it is asked once at boot.
cryptsetup luksFormat --type luks2 /dev/disk/by-partlabel/cryptroot
cryptsetup luksFormat --type luks2 /dev/disk/by-partlabel/cryptswap
cryptsetup open /dev/disk/by-partlabel/cryptroot cryptroot
cryptsetup open /dev/disk/by-partlabel/cryptswap cryptswap

mkswap -L swap /dev/mapper/cryptswap
swapon /dev/mapper/cryptswap

mkfs.btrfs -L nixos /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@root /mnt/@home /mnt/@nix
umount /mnt

O=compress=zstd,noatime
mount -o subvol=@root,$O /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,nix,boot}
mount -o subvol=@home,$O /dev/mapper/cryptroot /mnt/home
mount -o subvol=@nix,$O  /dev/mapper/cryptroot /mnt/nix
mount -o umask=0077 /dev/disk/by-label/BOOT /mnt/boot
```

The installer keyboard is US. After install, the boot passphrase prompt uses the layout from
`hosts/common/global/locale.nix` (dvorak), so pick a passphrase that types the same on both or
know where the keys are.

## 3. Hardware config and repo

```sh
nixos-generate-config --root /mnt --no-filesystems
grep stateVersion /mnt/etc/nixos/configuration.nix

nix-shell -p git gh
gh auth login
gh repo clone icaroponce/nix-config /mnt/home/icaro/nix-config
cd /mnt/home/icaro/nix-config
cp /mnt/etc/nixos/hardware-configuration.nix hosts/t450s/
# set system.stateVersion (hosts/t450s/default.nix) and home.stateVersion (home/icaro/t450s.nix)
git add -A
```

## 4. Install

```sh
nixos-install --flake /mnt/home/icaro/nix-config#t450s   # asks for a root password
nixos-enter --root /mnt -c 'passwd icaro'
chown -R 1000:100 /mnt/home/icaro
reboot
```

## 5. First boot

```sh
nmtui                                                     # wifi
gh auth login
git clone https://github.com/icaroponce/dotfiles ~/dotfiles
cd ~/dotfiles && stow --no-folding .
cd ~/nix-config && nix run home-manager -- switch --flake '.#icaro@t450s'
startx
```

## Recovery

A later change broke the system: reboot and pick an older generation in the systemd-boot menu.

It does not boot at all: boot the stick and

```sh
cryptsetup open /dev/disk/by-partlabel/cryptroot cryptroot
O=compress=zstd,noatime
mount -o subvol=@root,$O /dev/mapper/cryptroot /mnt
mount -o subvol=@home,$O /dev/mapper/cryptroot /mnt/home
mount -o subvol=@nix,$O  /dev/mapper/cryptroot /mnt/nix
mount /dev/disk/by-label/BOOT /mnt/boot
cd /mnt/home/icaro/nix-config        # fix, git add -A, then:
nixos-install --flake .#t450s --no-root-passwd
```
