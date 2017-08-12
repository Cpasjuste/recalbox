#!/bin/bash -e

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    --uuid-file)
    UUID_FILE="$2"
    shift
    ;;
    *)
    ;;
esac
shift
done

if [[ -z ${UUID_FILE} ]]; then
    echo -e "Usage:\n$0 --uuid-file path/to/file" && exit 1
fi

if [[ -f "${UUID_FILE}" ]];then
  cat "${UUID_FILE}"
else
  uuid=$(cat /proc/sys/kernel/random/uuid)
  echo "${uuid}" > "${UUID_FILE}"
  echo "${uuid}"
fi