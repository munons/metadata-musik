# Metadata Musik Auto-Tagger 🎵

Capek nyari lagu di laptop atau HP tapi isinya berantakan? Judulnya cuma `track01.mp3`, `unknown-artist`, atau bahkan gak ada info albumnya sama sekali? 

Nah, repositori ini solusinya! Ini adalah skrip otomatis berbasis CLI (terminal) yang bakal langsung "nembak" API resmi dari **MusicBrainz** buat nyari info lagu kamu secara massal. Begitu dapet, skrip ini otomatis menyuntikkan (*tagging*) metadata ke file musik lokal kamu biar rapi dan cakep pas dibuka di aplikasi pemutar musik.

## 🔥 Fitur Keren

- **Otomatis Tanpa Ribet**: Tinggal jalanin sekali, skrip langsung nyari judul asli, nama penyanyi, album, tahun rilis, sampai genre-nya sendiri.
- **Data Akurat**: Gak asal tebak, datanya diambil langsung dari MusicBrainz, salah satu basis data musik terbesar di internet.
- **Super Ringan**: Gak perlu aplikasi berat pakai UI yang bikin komputer lemot. Cukup modal terminal, kelar!

## 📁 Isi Repositori

- `eksekusi.sh`: Otak utama skrip yang bertugas nge-*scan* folder musik kamu dan ngobrol sama API MusicBrainz.
- `LICENSE`: Dokumen lisensi biar proyek ini tetap aman dan bersifat *open source* (GPL v3.0).

---

## 🛠️ Panduan Pasang & Cara Pakai

Pilih perangkat yang kamu pakai di bawah ini buat mulai eksekusi:

### 🪟 Pengguna Windows (Pake Git Bash)

Karena ini skrip Bash/Shell, kamu wajib pakai emulator terminal kayak **Git Bash** (otomatis ikut terpasang waktu kamu menginstal [Git for Windows](https://gitforwindows.org)).

1. **Pasang Paket Tambahan**: Windows gak punya manajer paket bawaan buat masang `jq`. Silakan unduh berkas `jq.exe` langsung di [Situs Resmi jq](https://jqlang.org), lalu masukin berkasnya ke folder instalasi Git Bash kamu (atau masukin ke *System PATH*).
2. **Pasang Python & Mutagen**: Buat urusan tulis-menulis tag lagu (`id3v2`), alternatif paling aman di Windows adalah pakai library Python bernama `mutagen` yang punya perintah klon bernama `mid3v2`. Ketik ini di terminal:
   ```bash
   pip install mutagen
   ```
3. **Sikat, Jalankan Skripnya**: Buka terminal Git Bash di dalam folder repositori ini, lalu arahkan ke folder musik kamu. Contohnya:
   ```bash
   ./eksekusi.sh /c/Users/NamaKamu/Music
   ```

### 🤖 Pengguna HP Android (Pake Termux)

Kamu bisa langsung ngerapihin koleksi lagu MP3 lewat HP Android modal aplikasi terminal [Termux](https://termux.dev) (saran: unduh versi terbaru via [F-Droid](https://f-droid.org/) biar gak dapet galat repositori).

1. **Izin Akses Memori**: Langkah wajib pertama biar Termux bisa ngebaca berkas musik di penyimpanan internal HP kamu:
   ```bash
   termux-setup-storage
   ```
2. **Pasang Tools Utama**: Perbarui isi paket Termux kamu terus pasang tools dasarnya:
   ```bash
   pkg update && pkg upgrade -y
   pkg install git curl jq python -y
   ```
3. **Pasang Tools Tagger Lagu**: Berhubung paket `id3v2` bawaan Linux jarang tersedia langsung di Termux, kita pakai trik via `mutagen` Python biar dapet perintah `mid3v2`:
   ```bash
   pip install mutagen
   ```
4. **Sikat, Jalankan Skripnya**: Arahkan target foldernya ke memori internal HP kamu (biasanya file musik ada di folder Download):
   ```bash
   ./eksekusi.sh /storage/emulated/0/Download
   ```

---

## 📄 Lisensi

Proyek ini pakai lisensi **GNU General Public License v3.0**. Intinya, kamu bebas banget buat pakai, ngoprek, modifikasi, bahkan sebarin lagi skrip ini sesuka hati, asal proyek turunan kamu nantinya tetep bersifat *open source*! Detail lengkapnya bisa kamu cek langsung di berkas [LICENSE](LICENSE).
