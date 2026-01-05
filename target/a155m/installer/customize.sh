LOG "- Downloading pre-compiled DTBO from the Llucs repository"
DOWNLOAD_FILE \
    "https://raw.githubusercontent.com/Llucs/android_device_samsung_a15/main/dtb/dtbo.img" \
    "$TMP_DIR/dtbo.img" || return 1

"$SRC_DIR/scripts/unsign_bin.sh" "$TMP_DIR/dtbo.img" || return 1