#!/usr/bin/env bash
# 按天切分 nginx 日志，导入 ClickHouse 之前先做这一步
# 用法: ./logsplit.sh access.log outdir
#
# access.log 的时间格式是 [21/Oct/2026:14:32:01 +0800]
# 用 awk -F 按方括号切成字段，比逐行 grep 快很多，2G 日志大概 40 秒

set -euo pipefail

src="${1:?需要源日志路径}"
out="${2:?需要输出目录}"

if [[ ! -f "$src" ]]; then
  echo "找不到 $src" >&2
  exit 1
fi

mkdir -p "$out"

awk -F'[][]' '
  NF >= 2 {
    split($2, t, ":")
    day = t[1]
    gsub("/", "-", day)
    print > ("'"$out"'/" day ".log")
  }
' "$src"

echo "切分完成: $(find "$out" -name '*.log' | wc -l) 个文件"
