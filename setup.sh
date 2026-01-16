#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== YouTube Music (audio-only) mpv setup ==="
echo

# ---------- Command name ----------
echo "Enter a command name(no spaces) to launch mpv with audio only."
read -rp "Command name (leave empty for default 'ytm'): " CMD_NAME
CMD_NAME="${CMD_NAME:-ytm}"

if ! [[ "$CMD_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "❌ Invalid command name - must be a single word"
  exit 1
fi

echo "[+] Command name: $CMD_NAME"
echo

# ---------- Dependencies ----------
echo "[+] Installing dependencies..."

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y mpv git python3-venv
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y mpv git python3
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --noconfirm mpv git python
else
  echo "⚠️  Could not detect package manager. Please install manually:"
  echo "    - mpv"
  echo "    - git"
  echo "    - python3-venv (or python3)"
  read -rp "Press Enter after installing dependencies..."
fi

echo

# ---------- mpv icon ----------
read -rp "Remove mpv Applications menu icon? (y/N): " REMOVE_ICON

if [[ "$REMOVE_ICON" =~ ^[Yy]$ ]]; then
  if [[ -f /usr/share/applications/mpv.desktop ]]; then
    sudo mv /usr/share/applications/mpv.desktop \
            /usr/share/applications/mpv.desktop.disabled
    echo "[+] mpv icon removed"
  fi
fi

echo

# ---------- yt-dlp venv ----------
VENV_DIR="$HOME/.config/mpv/venv"

echo "[+] Setting up yt-dlp venv..."

mkdir -p "$HOME/.config/mpv"

if [[ ! -d "$VENV_DIR" ]]; then
  python3 -m venv "$VENV_DIR"
fi

"$VENV_DIR/bin/pip" install --upgrade pip yt-dlp

echo

# ---------- youtube-upnext ----------
echo "[+] Installing youtube-upnext..."

TMP_DIR="$(mktemp -d)"
git clone https://github.com/cvzi/mpv-youtube-upnext "$TMP_DIR"

mkdir -p "$HOME/.config/mpv/scripts"
mkdir -p "$HOME/.config/mpv/script-opts"

cp "$TMP_DIR/youtube-upnext.lua" "$HOME/.config/mpv/scripts/"
cp "$TMP_DIR/youtube-upnext.conf" "$HOME/.config/mpv/script-opts/"

rm -rf "$TMP_DIR"

echo "[+] youtube-upnext installed"
echo

# ---------- Install wrapper ----------
echo "[+] Installing wrapper command..."

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

WRAPPER_SRC="$SCRIPT_DIR/wrapper.sh"
WRAPPER_DST="$BIN_DIR/$CMD_NAME"

if [[ ! -f "$WRAPPER_SRC" ]]; then
  echo "❌ Wrapper file not found: $WRAPPER_SRC"
  exit 1
fi

cp "$WRAPPER_SRC" "$WRAPPER_DST"
chmod +x "$WRAPPER_DST"

echo "[+] Installed command: $WRAPPER_DST"
echo

# ---------- PATH hint ----------
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
  echo "[!] $BIN_DIR is not in PATH"
  echo "    Add this line to your shell config:"
  echo
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo
fi

# ---------- Validation ----------
echo "[+] Validating installation..."

if "$VENV_DIR/bin/yt-dlp" --version >/dev/null 2>&1; then
  echo "[+] yt-dlp is working"
else
  echo "⚠️  Warning: yt-dlp validation failed"
fi

if command -v mpv >/dev/null 2>&1; then
  echo "[+] mpv is installed"
else
  echo "❌ Error: mpv not found"
  exit 1
fi

echo
echo "✅ Setup complete! Run '$CMD_NAME <YouTube-URL>' to play audio."

echo
echo "✅ Setup completed!"
echo "▶ Usage:"
echo "   $CMD_NAME \"https://music.youtube.com/watch?v=XXXX\""
echo
echo "▶ Uninstall:"
echo "   rm -rf \"$VENV_DIR\" \"$WRAPPER_DST\""
