#!/data/data/com.termux/files/usr/bin/bash

read -p "License Key: " LICENSE

HWID=$(getprop ro.serialno)

API="https://shrill-waterfall-1428.daniyalrhafiz.workers.dev"

HASIL=$(curl -s "$API/download?key=$LICENSE&hwid=$HWID")

if echo "$HASIL" | grep -q "Invalid"; then
    echo "License tidak valid"
    exit
fi

echo "$HASIL" > $PREFIX/bin/roblox_secure

chmod +x $PREFIX/bin/roblox_secure

roblox_secure
