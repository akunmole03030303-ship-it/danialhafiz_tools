#!/bin/bash

# Kode Warna ANSI & Style Tebal (Bold)
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BOLD="\033[1m"
NC="\033[0m" # Reset Warna

# URL Raw database.json & run.sh di repository kamu
DB_URL="https://raw.githubusercontent.com/akunmole03030303-ship-it/danialhafiz_tools/refs/heads/main/database.json"
RUN_URL="https://raw.githubusercontent.com/akunmole03030303-ship-it/danialhafiz_tools/refs/heads/main/run.sh"

clear
echo -e "${CYAN}${BOLD}"
echo "  ████████╗ ██████╗  ██████╗ ██╗     ███████╗"
echo "  ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝"
echo "     ██║   ██║   ██║██║   ██║██║     ███████╗"
echo "     ██║   ██║   ██║██║   ██║██║     ╚╚════██║"
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

# Download database.json ke file temporary
DB_FILE=$(mktemp)
curl -s "$DB_URL" -o "$DB_FILE"

if [ ! -s "$DB_FILE" ]; then
    echo -e "${RED}${BOLD}[!] Gagal terhubung ke database GitHub!${NC}"
    rm -f "$DB_FILE"
    exit 1
fi

# Parsing database.json menggunakan grep & sed (Tanpa Python)
RAW_LINE=$(grep -i "\"$MYKEY\"" "$DB_FILE")
rm -f "$DB_FILE"

if [ -z "$RAW_LINE" ]; then
    echo -e "${RED}${BOLD}[!] Gagal! License Key salah atau tidak terdaftar.${NC}"
    exit 1
fi

# Ambil nilai tanggal dari format JSON ("KEY": "YYYY-MM-DD HH:MM:SS")
EXP_DATE=$(echo "$RAW_LINE" | sed -E 's/.*:[[:space:]]*"([^"]+)".*/\1/')

if [ -z "$EXP_DATE" ]; then
    echo -e "${RED}${BOLD}[!] Gagal membaca tanggal kedaluwarsa dari database.${NC}"
    exit 1
fi

# Hitung Sisa Waktu (Epoch Time) menggunakan perintah date bawaan Termux
CURRENT_EPOCH=$(date +%s)
EXPIRE_EPOCH=$(date -d "$EXP_DATE" +%s 2>/dev/null || date -j -f "%Y-%m-%d %H:%M:%S" "$EXP_DATE" +%s 2>/dev/null)

if [ -z "$EXPIRE_EPOCH" ]; then
    echo -e "${RED}${BOLD}[!] Format tanggal expired di database tidak valid!${NC}"
    exit 1
fi

REMAINING=$((EXPIRE_EPOCH - CURRENT_EPOCH))

if [ $REMAINING -le 0 ]; then
    echo -e "${RED}${BOLD}[!] Gagal! License Key sudah kadaluwarsa pada ($EXP_DATE).${NC}"
    exit 1
fi

# Konversi sisa detik ke Hari, Jam, dan Menit
DAYS=$((REMAINING / 86400))
HOURS=$(((REMAINING % 86400) / 3600))
MINUTES=$(((REMAINING % 3600) / 60))

echo -e "${GREEN}${BOLD}[+] Lisensi valid!${NC}"
echo -e "${GREEN}[+] Sisa Masa Aktif : ${DAYS} hari, ${HOURS} jam, ${MINUTES} menit.${NC}"
echo -e "${YELLOW}[+] Memulai program...${NC}"
sleep 1

# Download script utama (run.sh)
bash <(curl -s "$RUN_URL")
