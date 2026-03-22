# Bambuddy Home Assistant Add-on

<img src="https://github.com/maziggy/bambuddy/blob/main/static/img/bambuddy_logo_dark.png?raw=true" alt="Bambuddy Logo" width="200"/>

[![Release][Bambuddy-version-shield]][Bambuddy-version]
[![Last update][Bambuddy-update-shield]][Bambuddy-update]
[![License][license-shield]](LICENSE)

Bambuddy is a powerful, self-hosted print archive and management system for Bambu Lab 3D printers.

## Features

- 📦 Print archive & history
- 🖨️ Bambu Lab printer management
- 📊 AMS filament tracking
- 👥 Multi-user support
- 🔔 Notifications
- 📷 Camera stream integration

## Installation

1. Add this repository to your Home Assistant Add-on Store:
   [![Add repository][repo-badge]][repo-url]

2. Install the **Bambuddy** add-on
3. Configure the options (port, debug, plate detection)
4. Start the add-on
5. Open the Web UI

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `debug` | `false` | Enable debug logging |
| `plate_detection` | `false` | Enable plate detection via opencv |

> ⚠️ **Hinweis:** `plate_detection` nutzt `py3-opencv` vom System – kein zusätzlicher Download nötig.

## Ports

| Port | Description |
|------|-------------|
| `8000` | Web interface (änderbar in den Netzwerk-Einstellungen) |

## Upstream

This add-on is based on [maziggy/bambuddy](https://github.com/maziggy/bambuddy).
Releases are synced automatically from upstream.

---

[Bambuddy-version-shield]: https://img.shields.io/badge/version-v0.2.2--0-blue.svg
[Bambuddy-version]: https://github.com/maziggy/bambuddy/releases
[Bambuddy-update-shield]: https://img.shields.io/badge/Updated%20on-2026--03--22-blue.svg
[Bambuddy-update]: https://github.com/maziggy/bambuddy/releases
[license-shield]: https://img.shields.io/badge/license-MIT-blue.svg
[repo-badge]: https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg
[repo-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fnetscout2001%2Fhomeassistant-addon-bambuddy
