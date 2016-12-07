#!/bin/bash

set -u
set -e

# Add a console on tty1
if [ -f "${TARGET_DIR}/etc/inittab" ]; then
  grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
  sed -i '/GENERIC_SERIAL/a\
  tty1::respawn:/sbin/getty -L tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# add boot partition mount
install -T -m 0644 ./system/skeleton/etc/fstab ${TARGET_DIR}/etc/fstab
echo '/dev/mmcblk0p1	/boot		vfat	defaults,rw	0	0' >> ${TARGET_DIR}/etc/fstab

function make_real_dir
{
  DIR="$1"

  if [ -h "${TARGET_DIR}${DIR}" ]; then
    echo "TARGET: replace ${TARGET_DIR}${DIR} as dir"
    rm -f "${TARGET_DIR}${DIR}"
    mkdir -p "${TARGET_DIR}${DIR}"
  fi

  if [ ! -d "${TARGET_DIR}${DIR}" ]; then
    echo "TARGET: create dir ${TARGET_DIR}${DIR}"
    mkdir -p "${TARGET_DIR}${DIR}"
  fi
}

# test for some key directories under rund
make_real_dir /etc/dropbear
make_real_dir /boot
