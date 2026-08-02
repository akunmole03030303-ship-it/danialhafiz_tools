#!/bin/bash

# Kode Warna ANSI & Style Tebal (Bold)
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BOLD="\033[1m"
NC="\033[0m" # Reset Warna

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

HWID=$(uname -n)
API_URL="https://shrill-waterfall-1428.daniyalrhafiz.workers.dev/download?key=${MYKEY}&hwid=${HWID}"

# Download script utama jika key valid
curl -s -L "$API_URL" -o run.sh

# Cek apakah file yang didownload berupa error JSON atau script asli
if grep -q "status" run.sh; then
    echo ""
    echo -e "${RED}${BOLD}[!] Gagal! Lisensi tidak valid, kedaluwarsa, atau HWID salah.${NC}"
    cat run.sh
    rm -f run.sh
    exit 1
fi

echo -e "${GREEN}${BOLD}[+] Lisensi valid! Memulai program...${NC}"
chmod +x run.sh
bash run.sh
