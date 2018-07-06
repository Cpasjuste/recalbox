#!/bin/bash

customDir=custom.generate
tmpDir=/tmp/customMake
hashList="$customDir/list.hash"
foundError=0

[[ -z $BUILDROOT_DIR && ! -d ./buildroot ]] && echo "You must set the env var BUILDROOT_DIR to the location of the buildroot dir to use this script" && exit 1
[[ -z $BUILDROOT_DIR && -d ./buildroot ]] && BUILDROOT_DIR="./buildroot"

mkdir -p "$customDir"
rm -rf "$tmpDir" ; mkdir -p "$tmpDir"
# Get modified files
for file in `cd "$BUILDROOT_DIR" ; git status -s | cut -c 4-` ; do 
  patchDest="$customDir/$(dirname $file)"
  patchName="$(basename $file).patch"
  echo "$file: $patchDest/$patchName"
  mkdir -p "$patchDest"
  # Create the patch
  if ! ( cd "$BUILDROOT_DIR" ; git diff $file 2>/dev/null ) > "$patchDest/$patchName" ; then
    if [[ ! -f "$BUILDROOT_DIR/$file" ]] ; then
      # This file was forcefully removed
      rm "$patchDest/$patchName"
      echo "--------------------------------  $file" >> "$hashList" || foundError=1
      continue
    fi
  fi

  # Copy the expected file
  cp "$BUILDROOT_DIR/$file" "$customDir/$file"
  # Get the original file hash -> unapply the patch 1st, then md5sum
  origDest="$tmpDir/$(dirname $file)"
  mkdir -p "$origDest"
  ( cd "$BUILDROOT_DIR" ; patch -p0 -R -o "$tmpDir/$file" $file < "$OLDPWD/$patchDest/$patchName" ) || foundError=1
  if [[ -s $patchDest/$patchName ]] ; then
    ( cd $tmpDir && md5sum $file ) >> "$hashList" || foundError=1
  else
    # The patch file is empty because the file is new to buildroot
    rm "$patchDest/$patchName"
    echo "++++++++++++++++++++++++++++++++  $file" >> "$hashList" || foundError=1
  fi
done

if [[ $foundError != 0 ]] ; then
  echo "Some errors were found in the process, can't switch the new custom tree"
  exit 1
fi

branchName=`( cd $BUILDROOT_DIR && git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* .* \([a-z0-9\.]\+\))/\1/' )`
echo $branchName
[[ -d ./custom ]] && mv custom "custom.pre-${branchName}"
mv "$customDir" custom || exit 1
echo "custom has been renamed to custom.pre-${branchName}"
echo "Your new custom dir is ready"
