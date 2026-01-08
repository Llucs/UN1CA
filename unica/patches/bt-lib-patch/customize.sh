if [ ! -f "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" ]; then
    LOG_STEP_IN "- Extracting libbluetooth_jni.so from com.android.bt.apex"

    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    EVAL "unzip -j \"$WORK_DIR/system/system/apex/com.android.bt.apex\" apex_payload.img -d \"$TMP_DIR\""

    mkdir -p "$TMP_DIR/tmp_out"
    EVAL "sudo mount -o ro \"$TMP_DIR/apex_payload.img\" \"$TMP_DIR/tmp_out\""
    EVAL "sudo cp \"$TMP_DIR/tmp_out/lib64/libbluetooth_jni.so\" \"$WORK_DIR/system/system/lib64/libbluetooth_jni.so\""
    EVAL "sudo umount \"$TMP_DIR/tmp_out\""

    rm -rf "$TMP_DIR"

    SET_METADATA "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"
    LOG_STEP_OUT
fi

LOG_STEP_IN "- Patching libbluetooth_jni.so (VaultKeeper)"

BIN="$WORK_DIR/system/system/lib64/libbluetooth_jni.so"
HEX="$(xxd -p -c 0 "$BIN")"

if echo "$HEX" | grep -q "2897773948050037"; then
    HEX_PATCH "$BIN" "2897773948050037" "289777392a000014"
    LOG "✓ VaultKeeper patch applied (pattern v1)"

elif echo "$HEX" | grep -q "183a009048050037"; then
    HEX_PATCH "$BIN" "183a009048050037" "183a00902a000014"
    LOG "✓ VaultKeeper patch applied (pattern v2)"

else
    LOG "\033[0;33m! No known VaultKeeper pattern found — skipping patch (expected on newer devices)\033[0m"
fi

LOG_STEP_OUT