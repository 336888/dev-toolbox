#!/usr/bin/env bash
# 批量压图：统一缩到指定宽度，转 webp，去掉 EXIF
# 用法: ./imgbatch.sh src/ out/ 1600

set -euo pipefail

src="${1:?需要源目录}"
out="${2:?需要输出目录}"
width="${3:-1600}"

# ImageMagick 7 的命令是 magick，6 是 convert，这里只认 7
if ! command -v magick >/dev/null; then
  echo "需要 ImageMagick 7：apt install imagemagick 或 brew install imagemagick" >&2
  exit 1
fi

mkdir -p "$out"

# -resize 1600x> 里的 > 表示只缩不放，小图保持原尺寸
# -strip 去掉 EXIF，省体积也免得泄露拍摄位置
find "$src" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0 |
while IFS= read -r -d '' f; do
  name=$(basename "${f%.*}")
  magick "$f" -resize "${width}x>" -strip -quality 82 "$out/$name.webp"
  echo "$f -> $out/$name.webp"
done

echo "完成，共 $(find "$out" -name '*.webp' | wc -l) 个文件"
