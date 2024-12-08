#!/bin/bash

# しきい値を設定 (例: 80%)
THRESHOLD=80

# コア数を取得
CORE_COUNT=$(sysctl -n hw.ncpu)

# 現在のCPU使用率を取得し、コア数を考慮して計算
CPU_USAGE=$(ps -A -o %cpu | awk '{sum+=$1} END {print sum / cores}' cores="$CORE_COUNT")

# しきい値を超えた場合に通知を送る
if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
  osascript -e "display notification \"CPU使用率が高くなっています: $CPU_USAGE%\" with title \"CPU Alert\""
fi

