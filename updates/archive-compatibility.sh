#!/bin/bash -e

UPGRADE_DIR="/usr/share/nginx/html/v1/upgrade"
ARCHIVE_DIR="/usr/share/nginx/html/updates/v1.0/stable"

for arch in $(ls "${UPGRADE_DIR}" | grep rpi); do
  echo "Creating directory ${ARCHIVE_DIR}/${arch}"
  mkdir -p "${ARCHIVE_DIR}/${arch}"
  for file in $(ls "${UPGRADE_DIR}/${arch}"); do
    echo "Linking file ${UPGRADE_DIR}/${arch}/${file} to ${ARCHIVE_DIR}/${arch}/${file}"
    ln -s "${UPGRADE_DIR}/${arch}/${file}" "${ARCHIVE_DIR}/${arch}/${file}"
  done
done