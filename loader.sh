#!/bin/bash

# Kode Warna ANSI & Style Tebal (Bold)
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BOLD="\033[1m"
NC="\033[0m" # Reset Warna

# URL Raw database.json di repository kamu
DB_URL="https://raw.githubusercontent.com/akunmole03030303-ship-it/danialhafiz_tools/refs/heads/main/database.json"
RUN_URL="https://raw.githubusercontent.com/akunmole03030303-ship-it/danialhafiz_tools/refs/heads/main/run.sh"

clear
echo -e "${CYAN}${BOLD}"
echo "  ████████╗ ██████╗  ██████╗ ██╗     ███████╗"
echo "  ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝"
echo "     ██║   ██║   ██║██║   ██║██║     ███████╗"
echo "     ██║   ██║   ██║██║   ██║██║     ╚════██║"
echo "     ██║   ╚██████╔╝╚██████╔╝███████╗███████║"
echo "     ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝"
echo "  ███████╗██╗███████╗██╗  ██╗██╗   ██╗"
echo "  ██╔════╝██║╚══███╔╝╚██╗██╔╝╚██╗ ██╔╝"
echo "  █████╗  ██║  ███╔╝  ╚███╔╝  ╚████╔╝ "
echo "  ██╔══╝  ██║ ███╔╝   ██╔██╗   ╚██╔╝  "
echo "  ██║     ██║███████╗██╔╝ ██╗   ██║   "
echo "  ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   "
echo -e "═════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}           ROBLOX MULTI-INSTANCE LOADER          ${NC}"
echo -e "${CYAN}═════════════════════════════════════════════════${NC}"
echo ""
echo -n -e "${CYAN}${BOLD} [?] Masukkan License Key : ${NC}"
read -r MYKEY

if [ -z "$MYKEY" ]; then
    echo -e "${RED}${BOLD}[!] Key tidak boleh kosong!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}[+] Menghubungkan ke server lisensi...${NC}"

# Download database.json dari GitHub
DB_JSON=$(curl -s "$DB_URL")

if [ -z "$DB_JSON" ]; then
    echo -e "${RED}${BOLD}[!] Gagal terhubung ke database GitHub!${NC}"
    exit 1
fi

# Cek apakah key terdaftar di database
if ! echo "$DB_JSON" | grep -q "\"$MYKEY\""; then
    echo -e "${RED}${BOLD}[!] Gagal! License Key salah atau tidak terdaftar.${NC}"
    exit 1
fi

# Ambil HWID unik perangkat
HWID=$(cat /etc/machine-id 2>/dev/null || uname -n)

# Ekstraksi Expired Date dan Active HWID
EXPIRED_DATE=$(echo "$DB_JSON" | grep -A 3 "\"$MYKEY\"" | grep "expired" | cut -d'"' -f4)
ACTIVE_HWID=$(echo "$DB_JSON" | grep -A 3 "\"$MYKEY\"" | grep "active_hwid" | cut -d'"' -f4)

# Cek Masa Aktif
CURRENT_DATE=$(date +%Y-%m-%d)
if [[ "$CURRENT_DATE" > "$EXPIRED_DATE" ]]; then
    echo -e "${RED}${BOLD}[!] Gagal! License Key sudah kedaluwarsa ($EXPIRED_DATE).${NC}"
    exit 1
fi

# Proteksi Anti-Double Device
if [ -n "$ACTIVE_HWID" ] && [ "$ACTIVE_HWID" != "$HWID" ]; then
    echo -e "${RED}${BOLD}[!] Akses Ditolak: Key sedang aktif di perangkat lain!${NC}"
    exit 1
fi

echo -e "${GREEN}${BOLD}[+] Lisensi valid! Memulai program...${NC}"
sleep 1

# Download script utama
curl -s -L "$RUN_URL" -o run.sh

if [ ! -f "run.sh" ] || grep -q "404: Not Found" run.sh; then
    echo -e "${RED}${BOLD}[!] Gagal mendownload script utama (run.sh).${NC}"
    exit 1
fi

chmod +x run.sh
bash run.sh "$MYKEY" "$HWID"
