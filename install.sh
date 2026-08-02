#!/data/data/com.termux/files/usr/bin/bash

clear
echo "=========================================="
echo "      ROBLOX SECURE INSTALLER v1.0        "
echo "=========================================="
echo ""

# Minta input license key dari user
read -p "🔑 Masukkan License Key lu: " LICENSE_KEY

if [ -z "$LICENSE_KEY" ]; then
    echo "❌ Error: License key tidak boleh kosong!"
    exit 1
fi

# Ambil HWID unik dari perangkat Termux
HWID=$(uname -n)

# Ganti URL di bawah dengan URL Cloudflare Worker lu yang aktif
WORKER_URL="https://shrill-waterfall-1428.workers.dev/download?key=${LICENSE_KEY}&hwid=${HWID}"

echo ""
echo "🔄 Menghubungkan ke server lisensi..."

# Download file dari worker
curl -s -L "$WORKER_URL" -o main.sh

# Cek apakah hasil download berupa pesan error JSON atau file beneran
if grep -q "status" main.sh; then
    echo ""
    echo "❌ Gagal! Lisensi tidak valid, sudah dipakai device lain, atau sudah mati."
    echo "Detail Pesan Dari Server:"
    cat main.sh
    rm -f main.sh
    exit 1
else
    chmod +x main.sh
    echo ""
    echo "✅ Lisensi Berhasil Diverifikasi!"
    echo "✅ Script berhasil diunduh dan dikunci ke perangkat ini."
    echo ""
    echo "🚀 Menjalankan program..."
    sleep 1
    ./main.sh
fi
