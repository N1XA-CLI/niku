#!/usr/bin/env python3
import gi, subprocess, threading, time, urllib.request, os, hashlib, socket, sys
from pathlib import Path

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GLib, GdkPixbuf

# ================= IPC =================
SOCKET_PATH = "/tmp/now_playing_widget.sock"

def send_toggle():
    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(SOCKET_PATH)
        s.sendall(b"toggle")
        s.close()
        return True
    except:
        return False

# ================= CONSTANTS =================
BACK_ICON = "⏮"
NEXT_ICON = "⏭"
PLAY_SYMBOL = "▶"
PAUSE_SYMBOL = "⏸"

CACHE_DIR = Path.home() / ".cache" / "now_playing"
CACHE_DIR.mkdir(parents=True, exist_ok=True)

# ================= MAIN =================
class NowPlaying(Gtk.Window):
    def __init__(self):
        super().__init__(title="Now Playing")
        self.set_default_size(420, 480)
        self.set_decorated(False)
        self.set_resizable(False)
        self.set_keep_above(True)

        self.visible_state = True
        self.last_track = None
        self.current_duration = 0.0

        overlay = Gtk.Overlay()
        self.add(overlay)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        box.set_margin_top(15)
        box.set_margin_bottom(15)
        box.set_margin_start(15)
        box.set_margin_end(15)
        overlay.add(box)

        # ===== STACK =====
        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        self.stack.set_transition_duration(300)
        box.pack_start(self.stack, True, True, 0)

        self.page = self.make_page(None, "", "")
        self.stack.add_named(self.page, "main")

        # ===== PROGRESS =====
        self.progress_box = Gtk.Box(spacing=8)

        self.time_label = Gtk.Label(label="0:00")
        self.duration_label = Gtk.Label(label="0:00")

        self.progress = Gtk.ProgressBar()
        self.progress.set_hexpand(True)

        self.progress_event = Gtk.EventBox()
        self.progress_event.add(self.progress)
        self.progress_event.connect("button-press-event", self.on_progress_click)

        self.progress_box.pack_start(self.time_label, False, False, 0)
        self.progress_box.pack_start(self.progress_event, True, True, 0)
        self.progress_box.pack_start(self.duration_label, False, False, 0)

        box.pack_start(self.progress_box, False, False, 0)

        # ===== CONTROLS =====
        controls = Gtk.Box(spacing=15)
        controls.set_halign(Gtk.Align.CENTER)

        self.back = Gtk.Button(label=BACK_ICON)
        self.play = Gtk.Button(label=PLAY_SYMBOL)
        self.next = Gtk.Button(label=NEXT_ICON)

        self.back.connect("clicked", lambda *_: subprocess.Popen(["playerctl", "previous"]))
        self.play.connect("clicked", lambda *_: subprocess.Popen(["playerctl", "play-pause"]))
        self.next.connect("clicked", lambda *_: subprocess.Popen(["playerctl", "next"]))

        controls.pack_start(self.back, False, False, 0)
        controls.pack_start(self.play, False, False, 0)
        controls.pack_start(self.next, False, False, 0)

        box.pack_start(controls, False, False, 0)

        self.show_all()

        threading.Thread(target=self.metadata_loop, daemon=True).start()
        threading.Thread(target=self.progress_loop, daemon=True).start()
        threading.Thread(target=self.socket_listener, daemon=True).start()

    # ================= UI =================
    def make_page(self, pix, title, artist):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)

        self.image = Gtk.Image()
        if pix:
            self.image.set_from_pixbuf(pix)

        self.title_label = Gtk.Label(label=title)
        self.artist_label = Gtk.Label(label=artist)

        box.pack_start(self.image, True, True, 0)
        box.pack_start(self.title_label, False, False, 0)
        box.pack_start(self.artist_label, False, False, 0)

        return box

    # ================= SEEK FIX =================
    def on_progress_click(self, widget, event):
        if self.current_duration <= 0:
            return

        width = widget.get_allocated_width()
        click_x = max(0, min(event.x, width))
        fraction = click_x / width
        new_pos = self.current_duration * fraction

        subprocess.Popen(["playerctl", "position", str(new_pos)])

    # ================= METADATA =================
    def metadata_loop(self):
        while True:
            try:
                r = subprocess.run(
                    ["playerctl", "metadata", "--format",
                     "{{title}}|{{artist}}|{{mpris:artUrl}}|{{status}}"],
                    capture_output=True, text=True
                )
                if r.returncode == 0:
                    title, artist, art, status = r.stdout.strip().split("|")

                    if status.lower() == "playing":
                        GLib.idle_add(self.play.set_label, PAUSE_SYMBOL)
                    else:
                        GLib.idle_add(self.play.set_label, PLAY_SYMBOL)

                    track = title + artist
                    if track != self.last_track:
                        self.last_track = track
                        pix = self.load_art(art)
                        GLib.idle_add(self.update_track, pix, title, artist)
            except:
                pass
            time.sleep(0.5)

    def update_track(self, pix, title, artist):
        if pix:
            self.image.set_from_pixbuf(pix)
        self.title_label.set_text(title)
        self.artist_label.set_text(artist)

    # ================= PROGRESS =================
    def progress_loop(self):
        while True:
            try:
                r = subprocess.run(
                    ["playerctl", "metadata", "--format",
                     "{{position}}|{{mpris:length}}"],
                    capture_output=True, text=True
                )
                if r.returncode == 0:
                    pos, dur = r.stdout.strip().split("|")
                    if pos and dur:
                        pos = int(pos) / 1e6
                        dur = int(dur) / 1e6
                        self.current_duration = dur

                        GLib.idle_add(self.progress.set_fraction, pos / dur)
                        GLib.idle_add(self.time_label.set_text, f"{int(pos//60)}:{int(pos%60):02d}")
                        GLib.idle_add(self.duration_label.set_text, f"{int(dur//60)}:{int(dur%60):02d}")
            except:
                pass
            time.sleep(0.5)

    # ================= ART =================
    def load_art(self, url):
        try:
            if url.startswith("file://"):
                path = url[7:]
            else:
                path = CACHE_DIR / (hashlib.md5(url.encode()).hexdigest() + ".png")
                if not path.exists():
                    urllib.request.urlretrieve(url, path)

            return GdkPixbuf.Pixbuf.new_from_file_at_scale(str(path), 390, 240, True)
        except:
            return None

    # ================= TOGGLE =================
    def toggle(self):
        if self.visible_state:
            self.hide()
        else:
            self.show_all()
        self.visible_state = not self.visible_state

    def socket_listener(self):
        if os.path.exists(SOCKET_PATH):
            os.remove(SOCKET_PATH)

        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.bind(SOCKET_PATH)
        s.listen(1)

        while True:
            c, _ = s.accept()
            if c.recv(16) == b"toggle":
                GLib.idle_add(self.toggle)
            c.close()

# ================= ENTRY =================
if __name__ == "__main__":
    if "--toggle" in sys.argv:
        if send_toggle():
            sys.exit(0)

    win = NowPlaying()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()
