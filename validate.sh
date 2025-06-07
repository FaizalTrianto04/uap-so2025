#!/bin/bash

# Validasi password dulu (hardcoded)
read -sp "🔒 Masukkan password validasi: " input
echo
if [ "$input" != "uap2025" ]; then
    echo "⛔ Akses ditolak. Password salah."
    exit 1
fi

echo "✅ Password diterima. Memulai validasi..."

# Modul 1: Cek user & group
echo "📦 Modul 1 - User & Group"
if getent passwd praktikum2025 >/dev/null; then
    echo "[✓] User praktikum2025 ditemukan"
else
    echo "[✗] User praktikum2025 tidak ditemukan"
fi

if getent group wheel | grep -w praktikum2025 >/dev/null; then
    echo "[✓] User tergabung dalam group wheel"
else
    echo "[✗] User tidak tergabung dalam group wheel"
fi

# Modul 2: Cek file konfigurasi
echo -e "\n📁 Modul 2 - Navigasi & Hak Akses File"
if [ -f /home/praktikum2025/UAP-MODUL2/konfigurasi.txt ]; then
    echo "[✓] File konfigurasi.txt ditemukan"
    perms=$(stat -c "%a" /home/praktikum2025/UAP-MODUL2/konfigurasi.txt)
    if [ "$perms" == "644" ]; then
        echo "[✓] Permission file benar (644)"
    else
        echo "[✗] Permission salah: $perms (seharusnya 644)"
    fi
else
    echo "[✗] File konfigurasi.txt tidak ditemukan"
fi

# Modul 3: Tuning system (cek command history)
echo -e "\n⚙️ Modul 3 - Tuning System"
if grep -qE 'sleep|kill|top|ps' /home/praktikum2025/.bash_history 2>/dev/null; then
    echo "[✓] Riwayat sleep/kill/top/ps ditemukan"
else
    echo "[✗] Riwayat tuning system tidak ditemukan"
fi

echo -e "\n✅ Validasi selesai."
