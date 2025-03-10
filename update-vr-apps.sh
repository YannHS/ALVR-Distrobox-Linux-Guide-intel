#!/bin/bash
cd $(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

if [ "$EUID" -eq 0 ]; then
   echo "Please don't run this script as root (no sudo)."
   exit 1
fi

source ./env.sh
source ./helper-functions.sh
source ./setup-env.sh

if [ "$(sanity_check_for_container)" -eq 1 ]; then
   echor "Couldn't find alvr container."
   echor "Please report setup.log and list bellow to https://github.com/alvr-org/ALVR-Distrobox-Linux-Guide/issues"
   distrobox list
   exit 1
fi

echog "Updating arch container, alvr"
distrobox enter --name "$container_name" --additional-flags "--env XDG_CURRENT_DESKTOP=X-Generic --env prefix='$prefix' --env container_name='$container_name'" -- 'paru -q --noprogressbar -Sy archlinux-keyring --noconfirm && paru -q --noprogressbar -Syu --noconfirm'

echog "Downloading alvr apk"
rm "$prefix/alvr_client_android.apk"
wget -q --show-progress -P "$prefix"/ "$ALVR_APK_LINK"

echog "Reinstalling wlxoverlay"
rm "$prefix/$WLXOVERLAY_FILENAME"
wget -O "$prefix/$WLXOVERLAY_FILENAME" -q --show-progress "$WLXOVERLAY_LINK"
chmod +x "$prefix/$WLXOVERLAY_FILENAME"

echog "Update finished."
