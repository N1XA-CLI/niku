<p align="center">
  <img src="assets/niri_niku_logo.png" width="300" />
</p>

<p align="center">
  <em>Minimilist, made powerful — a clean Niri setup for Arch Linux</em>
</p>

<p align="center">
  Built with love ❤️ and designed to stay simple, readable, and powerful.
</p>

---

## About

**Niku** is a minimal yet powerful **[Niri](https://github.com/niri-wm/niri) rice** for **Arch Linux**, focused on clarity, aesthetics, and real-world usability.

---
<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#assets">assets</a> •
  <a href="#videos">Videos</a> •
  <a href="#credits">Credits</a>
</p>

---

## assets

<!-- Hero shots (large) -->
<p align="center">
  <img src="assets/showcase/Screenshot_1.png" width="90%" />
</p>
<p align="center">
  <img src="assets/showcase/Screenshot_2.png" width="90%" />
</p>
<p align="center">
  <img src="assets/showcase/Screenshot_3.png" width="90%" />
</p>
<p align="center">
  <img src="assets/showcase/Screenshot_4.png" width="90%" />
</p>

---

<!-- Gallery (small) -->
<p align="center">
  <img src="assets/showcase/Screenshot-5.png" width="45%" />
  <img src="assets/showcase/Screenshot-6.png" width="45%" />
</p>

<p align="center">
  <img src="assets/showcase/Screenshot-7.png" width="45%" />
  <img src="assets/showcase/Screenshot-8.png" width="45%" />
</p>

<p align="center">
  <img src="assets/showcase/Screenshot-9.png" width="45%" />
  <img src="assets/showcase/Screenshot-10.png" width="45%" />
</p>

<p align="center">
  <img src="assets/showcase/Screenshot-11.png" width="45%" />
  <img src="assets/showcase/Screenshot-12.png" width="45%" />
</p>

<p align="center">
  <img src="assets/showcase/Screenshot-13.png" width="45%" />
  <img src="assets/showcase/Screenshot-14.png" width="45%" />
</p>

<p align="center">
  <img src="assets/showcase/Screenshot-15.png" width="45%" />
  <img src="assets/showcase/Screenshot-16.png" width="45%" />
</p>

<p align="center">
  <em>Minimal • Material You inspired • Workflow focused</em>
</p>

---

## Videos

Some things are better seen in motion.

You can find **Niku video demos**, looks, and workflow showcases on my Reddit profile:

👉 [Reddit](https://www.reddit.com/user/Scary-Combination-67/submitted/)

(New videos will be added as features evolve.)

---

## Features

- 🪟 Niri (Wayland)
- 🎨 Material You colors via `matugen`
- 🧩 GTK: adw-gtk3
- 🖼️ Icons: Papirus
- 🔤 Fonts: NerdFont
- ⚡ Clean, modular dotfiles
- 🧠 Beginner-friendly structure
- Complete Desktop Environment

---

## 📦 What’s Included

- Niri dotfiles
- GTK & system theming
- Workflow scripts
- One-shot installer (`install.sh`)
- Wallpaper & theme automation

All dependencies and configs are handled **inside the installer**.

---

## Requirements

- Arch Linux / Base Arch install
- git
- Minimal Arch (`optional`)

## Installation

1. Clone this repository:

```bash
git clone https://github.com/N1XA-CLI/niku.git ~/.niku
cd ~/.niku # Do not delete this folder
```

2. Make the installer executable:

```bash
chmod +x install.sh
```

3. Run the installer:

```bash
./install.sh
```

* Creates a backup of current config(**only config that it creates symlink**).
* It will **check and install missing packages** via `yay`.
* Creates **Symlink**.


4. Restart your session or apps if needed to see theme changes.

---

## DIRECTORIES

```bash
.config/
├── btop            # Resource Manager
├── cava            # Audio Visualiser
├── fastfetch       # System Fetcher
├── fish            # Terminal Shell
├── gtk-3.0         # Gtk-3 Config
├── gtk-4.0         # Gtk-4 Config
├── kitty           # Terminal
├── niku            # Main Config 
├── niri            # Niri Config
├── nvim            # NvChad
├── nwg-look        # Gtk Manager
├── rofi            # Launcher
├── spicetify       # Spotify Customiser
├── swaync          # Notification Center
├── waybar          # Status Bar
├── wlogout         # Powermenu
└── yazi            # File Manager

```

---

## Credits

- [***Shreyas***](https://github.com/shreyas-sha3) the base of the rice
- [***Aadritobasu***](https://github.com/aadritobasu/) for configs and 
inspiration.
- [***Noctalia***](https://github.com/noctalia-dev) for Color Scheme and mode generator
---

