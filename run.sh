#!/bin/bash

# --- PARAMETER DARI LOADER ---
MYKEY="$1"
HWID="$2"

# -------------------------------------------------------------
#  SCRIPT BY : FIZXY_TOOLS
# -------------------------------------------------------------

PLACES_ID_1="97598239454123"
PLACES_ID_2="121864768012064"

APPS=$(pm list packages | grep "com.roblox" | cut -d ":" -f2)

if [ -z "$APPS" ]; then
    echo -e "\033[1;31m[!] Error: Tidak ada aplikasi Roblox (com.roblox*) yang terdeteksi!\033[0m"
    exit 1
fi

CFG="/data/data/com.termux/files/home/roblox_config"
JOIN_CONFIG="/data/data/com.termux/files/home/.fizxy_join_config"

TOTAL_APPS=0
for PKG in $APPS; do
    TOTAL_APPS=$((TOTAL_APPS + 1))
done

# =============================================================
SYSTEM_JOIN_SETTINGS() {
    HAVE_EXISTING=0

    if [ -f "$JOIN_CONFIG" ]; then
        HAVE_EXISTING=1
    fi

    if [ "$HAVE_EXISTING" = "1" ]; then
        clear
        echo "================================================="
        echo "        SETTING JOIN FIZXY                      "
        echo "================================================="
        echo " 1. Gunakan data join sebelumnya?"
        echo " 2. Buat metode join yang baru!"
        echo "================================================="
        printf "[?] Pilihan (1/2): "
        read -r SESSION_CHOICE < /dev/tty
        
        if [ "$SESSION_CHOICE" = "1" ]; then
            source "$JOIN_CONFIG"
            return
        fi
    fi

    clear
    echo "================================================="
    echo "        ROBLOX REJOIN BY FIZXY                   "
    echo "================================================="
    echo " Pilih Map:"
    echo " 1. Grow A Garden 2"
    echo " 2. Fish It"
    echo "================================================="
    printf "[?] Masukkan pilihan Map (1/2): "
    read -r MAP_CHOICE < /dev/tty
    
    if [ "$MAP_CHOICE" = "1" ]; then
        PUBLIC_PLACE_ID="$PLACES_ID_1"
        MAP_NAME="Grow A Garden 2"
    elif [ "$MAP_CHOICE" = "2" ]; then
        PUBLIC_PLACE_ID="$PLACES_ID_2"
        MAP_NAME="Fish It"
    else
        echo "[!] Pilihan Map tidak valid!"
        exit 1
    fi

    clear
    echo "================================================="
    echo "        ROBLOX AUTO JOINER                       "
    echo "================================================="
    echo " Map Terpilih           : $MAP_NAME"
    echo " Jumlah Roblox terdeteksi : $TOTAL_APPS Aplikasi"
    echo " Silahkan pilih metode join:"
    echo " 1. Join public server ($MAP_NAME)"
    echo " 2. Join private server yang sama (1 Link untuk semua)"
    echo " 3. Join private server beda-beda tiap akun ($TOTAL_APPS Link)"
    echo "================================================="
    printf "[?] Masukkan pilihan (1/2/3): "
    read -r MENU_CHOICE < /dev/tty

    if [ -z "$MENU_CHOICE" ]; then
        echo "[!] Input tidak boleh kosong!"
        exit 1
    fi

    case "$MENU_CHOICE" in
        1)
            MENU_CHOICE="1"
            SHARED_LINK="https://www.roblox.com/games/start?placeId=$PUBLIC_PLACE_ID"
            ;;
        2)
            MENU_CHOICE="2"
            printf "[?] Tempel Link Private Server: "
            read -r SHARED_LINK < /dev/tty
            if [ -z "$SHARED_LINK" ]; then
                echo "[!] Link tidak boleh kosong!"
                exit 1
            fi
            ;;
        3)
            MENU_CHOICE="3"
            echo "-------------------------------------------------"
            i=1
            for PKG in $APPS; do
                printf "[?] Masukkan link private untuk akun ke-$i ($PKG): "
                read -r LINK_INPUT < /dev/tty
                if [ -z "$LINK_INPUT" ]; then
                    echo "[!] Link tidak boleh kosong!"
                    exit 1
                fi
                eval "LINK_ACC_$i=\"$LINK_INPUT\""
                i=$((i + 1))
            done
            echo "-------------------------------------------------"
            ;;
        *)
            echo "[!] Pilihan tidak valid!"
            exit 1
            ;;
    esac

    # Simpan Konfigurasi Baru
    echo "MENU_CHOICE=\"$MENU_CHOICE\"" > "$JOIN_CONFIG"
    echo "SHARED_LINK=\"$SHARED_LINK\"" >> "$JOIN_CONFIG"
    j=1
    for PKG in $APPS; do
        eval "current_link=\$LINK_ACC_$j"
        if [ -n "$current_link" ]; then
            eval "echo \"LINK_ACC_$j=$current_link\"" >> "$JOIN_CONFIG"
        fi
        j=$((j + 1))
    done
}

SYSTEM_JOIN_SETTINGS

echo " -------------------------------------------------"
echo "[+] Optimizing hardware temperature (Dimming Screen)..."
settings put system screen_brightness 0 > /dev/null 2>&1

sleep 1
echo ""
echo -e "\033[1;32m[+] Berhasil memuat sistem untuk Key: $MYKEY\033[0m"

# --- BAGIAN EKSEKUSI / MEMBUKA ROBLOX ---
echo "[+] Menjalankan Roblox multi-instance..."
i=1
for PKG in $APPS; do
    if [ "$MENU_CHOICE" = "1" ] || [ "$MENU_CHOICE" = "2" ]; then
        TARGET_LINK="$SHARED_LINK"
    elif [ "$MENU_CHOICE" = "3" ]; then
        eval "TARGET_LINK=\$LINK_ACC_$i"
    fi

    # Eksekusi membuka aplikasi Roblox dengan link tujuan
    am start -n "$PKG/com.roblox.client.ActivityProtocolLauncher" -a android.intent.action.VIEW -d "$TARGET_LINK" > /dev/null 2>&1
    
    sleep 2
    i=$((i + 1))
done

echo "[+] Semua instance Roblox berhasil dibuka!"
