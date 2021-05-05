#!/usr/bin/env bash
set -euo pipefail

mkdir -p iso/nocloud/
touch iso/nocloud/meta-data
rm -rf 'iso/[BOOT]/'
md5sum iso/.disk/info > iso/md5sum.txt
sed -i 's|iso/|./|g' iso/md5sum.txt
sed -i 's|---|autoinstall ds=nocloud\\\;s=/cdrom/nocloud/ ---|g' iso/boot/grub/grub.cfg
sed -i 's|---|autoinstall ds=nocloud;s=/cdrom/nocloud/ ---|g' iso/isolinux/txt.cfg

cp autoinstall-masters.yaml iso/nocloud/user-data

xorriso -as mkisofs -r \
    -V Ubuntu\ masters\ amd64 \
    -o /build/ubuntu-20.04.2-live-server-amd64-autoinstall-masters.iso \
    -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
    -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
    -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin  \
    iso/boot iso

cp autoinstall-workers.yaml iso/nocloud/user-data

xorriso -as mkisofs -r \
    -V Ubuntu\ workers\ amd64 \
    -o /build/ubuntu-20.04.2-live-server-amd64-autoinstall-workers.iso \
    -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
    -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
    -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin  \
    iso/boot iso
