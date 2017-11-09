#!/bin/bash

set -u
set -e

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
make_real_dir /var/db
make_real_dir /var/tmp/asterisk/sounds/custom-sounds

# add boot partition mount
grep -q "^/dev/mmcblk0p1" $TARGET_DIR/etc/fstab || echo "/dev/mmcblk0p1	/boot		vfat	defaults,rw	0	0" >> $TARGET_DIR/etc/fstab
