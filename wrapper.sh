#!/usr/bin/env bash

VENV_DIR="$HOME/.config/mpv/venv"
UPDATE_STAMP="$VENV_DIR/.last_update"
DAY_SECONDS=86400

# Validate venv exists
if [[ ! -d "$VENV_DIR" ]] || [[ ! -x "$VENV_DIR/bin/pip" ]]; then
  echo "Error: yt-dlp venv not found. Run setup.sh first." >&2
  exit 1
fi

# Inject venv yt-dlp into PATH
export PATH="$VENV_DIR/bin:$PATH"

# Auto-update yt-dlp (once per day)
now=$(date +%s)
last_update=0

[[ -f "$UPDATE_STAMP" ]] && last_update=$(cat "$UPDATE_STAMP")

if (( now - last_update > DAY_SECONDS )); then
  if "$VENV_DIR/bin/pip" install -q --upgrade yt-dlp 2>/dev/null; then
    date +%s > "$UPDATE_STAMP"
  fi
fi

# Launch mpv (audio-only)
exec mpv --profile=music "$@"
