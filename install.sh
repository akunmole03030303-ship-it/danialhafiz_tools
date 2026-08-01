#!/data/data/com.termux/files/usr/bin/bash

URL="https://raw.githubusercontent.com/akunmole03030303-ship-it/danialhafiz_tools/main/roblox_secure"

curl -L "$URL" -o $PREFIX/bin/roblox_secure
chmod +x $PREFIX/bin/roblox_secure

echo "Install berhasil."
roblox_secure
