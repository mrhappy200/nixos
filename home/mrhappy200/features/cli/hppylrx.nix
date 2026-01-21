{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "hppylrx";

  runtimeInputs = [
    pkgs.python3
    pkgs.python3Packages.python-mpd2
    pkgs.python3Packages.mutagen
    pkgs.python3Packages.pylrc
  ];

  text = ''
    #!/usr/bin/env python3
    import os
    import time
    from mpd import MPDClient, CommandError
    from mutagen import File
    from mutagen.id3 import SYLT
    import pylrc

    MPD_HOST = "localhost"
    MPD_PORT = 6600
    POLL_INTERVAL = 0.1

    client = MPDClient()
    client.timeout = 10
    client.idletimeout = None

    def connect():
        while True:
            try:
                client.connect(MPD_HOST, MPD_PORT)
                return
            except Exception:
                time.sleep(1)

    def get_music_dir():
        try:
            cfg = client.config()
            return cfg.get("music_directory")
        except Exception:
            return None

    def load_lyrics(path):
        audio = File(path)
        if not audio:
            return None

        if audio.tags:
            for tag in audio.tags.values():
                if isinstance(tag, SYLT):
                    return sorted(
                        [(t / 1000.0, text) for text, t in tag.synced],
                        key=lambda x: x[0]
                    )

        for key in ("LYRICS", "UNSYNCEDLYRICS"):
            if key in audio:
                lrc = pylrc.parse(audio[key][0])
                return [(line.time, line.text) for line in lrc]

        return None

    def elapsed_seconds(status):
        try:
            return float(status.get("elapsed", 0))
        except ValueError:
            return 0.0

    connect()

    MUSIC_DIR = get_music_dir() or "/srv/music"

    current_file = None
    lyrics = []
    last_index = -1
    last_elapsed = 0.0
    was_paused = False

    while True:
        try:
            status = client.status()
            song = client.currentsong()
        except (CommandError, ConnectionError):
            connect()
            continue

        if not song or "file" not in song:
            time.sleep(POLL_INTERVAL)
            continue

        full_path = os.path.realpath(os.path.join(MUSIC_DIR, song["file"]))

        if full_path != current_file:
            lyrics = load_lyrics(full_path) or []
            current_file = full_path
            last_index = -1
            last_elapsed = 0.0

        state = status.get("state")
        elapsed = elapsed_seconds(status)

        if state == "pause":
            was_paused = True
            time.sleep(POLL_INTERVAL)
            continue

        if was_paused:
            was_paused = False
            last_elapsed = elapsed

        if elapsed < last_elapsed:
            last_index = -1

        last_elapsed = elapsed

        for i in range(last_index + 1, len(lyrics)):
            t, text = lyrics[i]
            if elapsed >= t:
                print(text, flush=True)
                last_index = i
            else:
                break

        time.sleep(POLL_INTERVAL)
  '';
}
