#!/bin/bash

# plist テンプレートファイルと出力先の設定
PLIST_TEMPLATE="com.user.cpu_monitor.plist"
PLIST_OUTPUT="$HOME/Library/LaunchAgents/com.user.cpu_monitor.plist"

# カレントディレクトリの絶対パスを取得
CURRENT_DIR=$(pwd)

# plist テンプレートの存在確認
if [ ! -f "$PLIST_TEMPLATE" ]; then
  echo "Error: $PLIST_TEMPLATE が現在のディレクトリに見つかりません。"
  exit 1
fi

# プレースホルダを置換して一時ファイルに保存
TEMP_PLIST="/tmp/com.user.cpu_monitor.plist"
sed "s|{{path}}|$CURRENT_DIR|g" "$PLIST_TEMPLATE" > "$TEMP_PLIST"

# LaunchAgents ディレクトリに配置
if [ ! -d "$HOME/Library/LaunchAgents" ]; then
  mkdir -p "$HOME/Library/LaunchAgents"
  echo "Created $HOME/Library/LaunchAgents"
fi
mv "$TEMP_PLIST" "$PLIST_OUTPUT"
echo "Copied updated plist to $PLIST_OUTPUT"

# launchctl でロード
launchctl unload "$PLIST_OUTPUT" 2>/dev/null # 既にロードされている場合はアンロード
launchctl load "$PLIST_OUTPUT"
echo "Loaded $PLIST_OUTPUT with launchctl"

# 完了メッセージ
echo "Installation complete. CPU monitor is now active."

