#!/bin/bash -e

echo ok
curl -vL https://github.com/recalbox/recalbox-rescue/releases/download/v4.1.0/recalbox-rescue-4.1.0.tar.xz > recalbox-rescue-4.1.0.tar.xz
xz -d recalbox-rescue-4.1.0.tar.xz

mkdir recalbox-rescue-4.1.0
tar vfx recalbox-rescue-4.1.0.tar -C recalbox-rescue-4.1.0

cd recalbox-rescue-4.1.0

for rpi in rpi1 rpi2 rpi3; do
  curl -vfL https://archivev2.recalbox.com/v1/upgrade/${rpi}/boot.tar.xz > os/recalboxOS-${rpi}/boot.tar.xz
  curl https://archivev2.recalbox.com/v1/upgrade/rpi1/boot.tar.xz.sha1 > os/recalboxOS-${rpi}/boot.tar.xz.sha1
  [[ "$(cat os/recalboxOS-${rpi}/boot.tar.xz.sha1 | awk '{print $1}')" != "$(sha1sum os/recalboxOS-${rpi}/boot.tar.xz)" ]] && exit 1

  curl -vfL https://archivev2.recalbox.com/v1/upgrade/${rpi}/root.tar.xz > os/recalboxOS-${rpi}/root.tar.xz
  curl https://archivev2.recalbox.com/v1/upgrade/rpi1/root.tar.xz.sha1 > os/recalboxOS-${rpi}/root.tar.xz.sha1
  [[ "$(cat os/recalboxOS-${rpi}/root.tar.xz.sha1 | awk '{print $1}')" != "$(sha1sum os/recalboxOS-${rpi}/root.tar.xz)" ]] && exit 1
done

zip -r recalbox-final-all-rpi.zip *
