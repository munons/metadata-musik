#!/bin/bash
# ======================================================
# Script Name : metadata-audio.sh
# Version     : 1
# Description : Auto metadata + cover + genre dari MusicBrainz
# Author      : munons
# ======================================================

mkdir -p render
logfile="process.log"
: >"$logfile"

# =========================
# 🔍 Cek dependency
# =========================
for cmd in ffmpeg ffprobe curl jq; do
  command -v $cmd >/dev/null || {
    echo "❌ $cmd belum terinstall"
    exit 1
  }
done

# =========================
# 🖼️ Cek cover eksternal
# =========================
cover=$(ls cover.{jpg,jpeg,png,webp} 2>/dev/null | head -n 1)

if [ -n "$cover" ]; then
  echo "✅ Pakai cover: $cover"
else
  echo "⚠️ Tidak ada cover eksternal"
fi

# =========================
# 🌐 Fungsi MusicBrainz
# =========================
get_metadata_mb() {
  local artist="$1"
  local title="$2"

  query=$(printf "%s %s" "$artist" "$title" | sed 's/ /%20/g')

  json=$(curl -s "https://musicbrainz.org/ws/2/recording/?query=$query&fmt=json&limit=1")

  artist_mb=$(echo "$json" | jq -r '.recordings[0]."artist-credit"[0].name // empty')
  title_mb=$(echo "$json" | jq -r '.recordings[0].title // empty')
  album_mb=$(echo "$json" | jq -r '.recordings[0].releases[0].title // empty')

  # 🔥 ambil genre paling populer
  genre_mb=$(echo "$json" | jq -r '.recordings[0].tags | sort_by(-.count) | .[0].name // empty')

  echo "$artist_mb|$title_mb|$album_mb|$genre_mb"
}

# =========================
# 🔄 Loop file audio
# =========================
for f in *.{mp3,MP3,m4a,M4A,flac,FLAC,wav,WAV,ogg,OGG}; do
  [ -e "$f" ] || continue

  filename="${f%.*}"
  echo ""
  echo "🎧 Processing: $f"

  # =========================
  # 📂 Parsing nama file
  # =========================
  if [[ "$filename" == *" - "* ]]; then
    artis_file=$(echo "$filename" | cut -d '-' -f1 | xargs)
    judul_file=$(echo "$filename" | cut -d '-' -f2- | xargs)
  else
    artis_file="$filename"
    judul_file="$filename"
  fi

  echo "🔎 Cari metadata online..."

  # =========================
  # 🌐 Ambil dari MusicBrainz
  # =========================
  mb_data=$(get_metadata_mb "$artis_file" "$judul_file")

  artis=$(echo "$mb_data" | cut -d'|' -f1)
  judul=$(echo "$mb_data" | cut -d'|' -f2)
  album=$(echo "$mb_data" | cut -d'|' -f3)
  genre=$(echo "$mb_data" | cut -d'|' -f4)

  # =========================
  # 🧠 Fallback
  # =========================
  artis="${artis:-$artis_file}"
  judul="${judul:-$judul_file}"
  album="${album:-Japan}"
  genre="${genre:-Japan}"

  echo "   🎵 Artist: $artis"
  echo "   🎶 Title : $judul"
  echo "   💿 Album : $album"
  echo "   🎼 Genre : $genre"

  out="render/${filename}.mp3"

  # =========================
  # 🎼 Encode + Metadata
  # =========================
  if [ -n "$cover" ]; then
    ffmpeg -y -i "$f" -i "$cover" \
      -map 0:a -map 1 \
      -map_metadata -1 \
      -c:a libmp3lame -b:a 320k \
      -metadata artist="$artis" \
      -metadata title="$judul" \
      -metadata album="$album" \
      -metadata genre="$genre" \
      -metadata comment="by MUNONS" \
      -disposition:v attached_pic \
      "$out" >>"$logfile" 2>&1
  else
    ffmpeg -y -i "$f" \
      -map_metadata -1 \
      -c:a libmp3lame -b:a 320k \
      -metadata artist="$artis" \
      -metadata title="$judul" \
      -metadata album="$album" \
      -metadata genre="$genre" \
      -metadata comment="by MUNONS" \
      "$out" >>"$logfile" 2>&1
  fi

  # =========================
  # ✅ Status
  # =========================
  if [ $? -eq 0 ]; then
    echo "✅ Selesai → $out"
  else
    echo "❌ Gagal: $f (cek $logfile)"
  fi
done

echo ""
echo "🎯 Semua proses selesai!"
echo "📁 Hasil ada di folder: render/"