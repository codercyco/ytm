# YouTube Music Mpv Setup

Command line YouTube Music setup that streams audio only content using mpv, with automatic queue continuation via the youtube upnext script by [cvzi](https://github.com/cvzi).

## Features

- Audio only streaming (no video overhead)
- Auto updates yt-dlp daily
- Automatic next track playback
- Lightweight and fast

## Installation

1. Clone or download this repository
2. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
3. Follow the prompts to choose a command name (default: `ytm`)
4. If needed, add `~/.local/bin` to your PATH

## Usage

Play any YouTube Music track or playlist:
```bash
ytm "https://music.youtube.com/watch?v=XXXXX"
```

The player will automatically continue to the next track when the current one finishes.

## Uninstall

Remove the installation with:
```bash
rm -rf ~/.config/mpv/venv ~/.local/bin/ytm
```

Replace `ytm` with your custom command name if you chose a different one during setup.

## Acknowledgements

- **[mpv](https://mpv.io/)** - A free, open source, and cross-platform media player
- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** - A youtube-dl fork with additional features
- **[youtube-upnext](https://github.com/cvzi/mpv-youtube-upnext)** by cvzi - mpv script for automatic playlist continuation
