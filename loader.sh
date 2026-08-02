#!/bin/bash

# Kode Warna ANSI
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m" # Reset Warna

clear
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}      ROBLOX MULTI-INSTANCE LOADER      ${NC}"
echo -e "${CYAN}========================================${NC}"
echo -n -e "${CYAN}Masukkan License Key: ${NC}"
read -r MYKEY

if [ -z "$MYKEY" ]; then
    echo -e "${RED}[!] Key tidak boleh kosong!${NC}"
    exit 1
fi

echo -e "${YELLOW}[+] Menghubungkan ke server lisensi...${NC}"

HWID=$(uname -n)
API_URL="https://shrill-waterfall-1428.daniyalrhafiz.workers.dev/download?key=${MYKEY}&hwid=${HWID}"

# Download script utama jika key valid
curl -s -L "$API_URL" -o run.sh

# Cek apakah file yang didownload berupa error JSON atau script asli
if grep -q "status" run.sh; then
    echo ""
    echo -e "${RED}[!] Gagal! Lisensi tidak valid, kedaluwarsa, atau HWID salah.${NC}"
    cat run.sh
    rm -f run.sh
    exit 1
fi

echo -e "${GREEN}[+] Lisensi valid! Memulai program...${NC}"
chmod +x run.sh
bash run.sh
