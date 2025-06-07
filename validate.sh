#!/bin/bash
 
# 1. Siapkan script tersembunyi
cat <<'EOF' > /etc/.validate_uap_so2025
#!/bin/bash

# Cek argumen
if [ "$1" != "--validate" ]; then
  echo "❌ Gunakan: UAP-SO2025 --validate"
  exit 1
fi

# Minta password
echo -n "🔒 Masukkan password validasi: " > /dev/tty
read -s input < /dev/tty
echo > /dev/tty

if [ "$input" != "uap2025" ]; then
    echo "⛔ Akses ditolak. Password salah."
    exit 1
fi

echo "✅ Password diterima. Memulai validasi..."

# Modul 1
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

# Modul 2
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

# Modul 3
echo -e "\n⚙️ Modul 3 - Tuning System"
if grep -qE 'sleep|kill|top|ps' /home/praktikum2025/.bash_history 2>/dev/null; then
    echo "[✓] Riwayat sleep/kill/top/ps ditemukan"
else
    echo "[✗] Riwayat tuning system tidak ditemukan"
fi

echo -e "\n✅ Validasi selesai."
EOF

# 2. Proteksi file
chmod 700 /etc/.validate_uap_so2025
chown root:root /etc/.validate_uap_so2025

# 3. Buat alias command global
ln -sf /etc/.validate_uap_so2025 /usr/local/bin/UAP-SO2025

# 4. Output minimal
echo "✅ Script berhasil di-setup. Gunakan nanti dengan: UAP-SO2025 --validate"
