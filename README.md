# YouTube Music Streaming with mpv 

Command line YouTube Music setup that streams audio only content using mpv, with automatic queue continuation via the youtube upnext script by [cvzi](https://github.com/cvzi).

## Features

- Audio only streaming (Never downloads the video stream)
- Auto updates yt-dlp daily
- Automatic next track playback
- Lightweight and fast
- Automatic PATH configuration
- Configurable buffer size

## Installation

1. Clone or download this repository
2. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
3. During setup, you'll be prompted to:
   - Choose a command name (default: `ytm`)
   - Set buffer size in MiB (default: 5)
   - Remove mpv desktop icon (optional)

## Usage

Play any YouTube Music track or playlist:
```bash
ytm "https://music.youtube.com/watch?v=XXXXX"
```

The player will automatically continue to the next track when the current one finishes.

## Uninstall

Remove the installation with:
```bash
rm -rf ~/.config/mpv/venv ~/.local/bin/ytm ~/.config/mpv/scripts/youtube-upnext.lua ~/.config/mpv/script-opts/youtube-upnext.conf
```

Replace `ytm` with your custom command name if you chose a different one during setup.

## Acknowledgements

- **[mpv](https://mpv.io/)**  
  A free, open source, and cross-platform media player

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)**  
  A youtube-dl fork with additional features

- **[youtube-upnext](https://github.com/cvzi/mpv-youtube-upnext)**  
  A userscript for mpv  for load the up next youtube video
