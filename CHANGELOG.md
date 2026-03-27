## [0.2.2.2-0] - 2026-03-27

  **Bambuddy v0.2.2.2**

  **Highlights**

  - External Folder Mounting for File Manager (#124) — Mount NAS shares, USB drives, or network storage into the File Manager without copying files.
  - Persistent Auto-Off for Smart Plugs (#826) — "Keep Enabled" toggle keeps auto-off active between prints instead of one-shot behavior. Great for accessories like BentoBox filters.

  **New Features**

  - Persistent Auto-Off for Smart Plugs (#826) — Smart plugs now have a "Keep Enabled" toggle under Auto Off settings. When enabled, auto-off stays active between prints instead of requiring manual re-enablement after each print.
  - Missing Spool Assignment Notification (#763) — Warning toast and push notification when a print starts with unmapped AMS slots. Includes printer name, slot labels, and expected material. Contributed by @Keybored02.
  - Mid-Print Spool Reassignment Tracking (#763) — Usage tracking now correctly handles spool swaps during a print. Contributed by @Keybored02.
  - Auto-Link Untagged Inventory Spools on AMS Insert (#538) — Automatically links RFID tags to existing untagged spools with matching material/color instead of creating duplicates. FIFO ordering.
  - External Folder Mounting for File Manager (#124) — Mount host directories (NAS, USB, network storage) into the File Manager. Files are indexed but accessed from their original location — nothing is copied. Supports read-only mode, hidden file filtering, and thumbnail extraction.
  - Ukrainian Hryvnia Currency (#815) — Added UAH/₴ to known currencies for filament cost tracking.

  **Improved**

  - Spool Assignment Changes Sync Across Tabs — WebSocket broadcast keeps all clients in sync
  - Unassign Button in Edit Spool Modal — Remove AMS slot assignment without deleting the tag
  - Spool Notes in Assign Spool Modal (#793) — Hover tooltip shows spool notes.
  - WiFi Safeguard for SpoolBuddy Pi — APT hook preserves WiFi connections during system upgrades
  - SpoolBuddy Inventory Page — New kiosk page with spool grid, search, filter pills, and tap-to-detail view
  - SpoolBuddy AMS Slot Action Picker — Contextual actions (Configure, Assign/Unassign) on slot tap
  - SpoolBuddy Assign-to-AMS Material Mismatch Warnings — Warns on material/profile mismatch when assigning spools
  - SpoolBuddy System Tab — Live OS stats (CPU temp, memory, disk, uptime) from the Raspberry Pi
  - SpoolBuddy Auto-Navigate on Tag Scan — Returns to dashboard when a tag is scanned on any page
  - SpoolBuddy Swipe to Switch Printers — Left/right swipe cycles through online printers
  - SpoolBuddy Boot Splash Polished — New logo-only splash with green glow bloom
  - SpoolBuddy Virtual Keyboard Layout Fix — Keyboard now participates in flex layout; number inputs work
  - SpoolBuddy Settings Device Tab Compacted — Fits on touchscreen without scrolling
  - SpoolBuddy Init & Diagnostic Improvements (#814) — Contributed by @Keybored02
  - Removed Diagnostic Buttons from Write Tag Page — Diagnostics moved to Settings only

  **Fixed**

  - Print Fails on Files With Spaces in Name (#824) — Filenames with spaces caused the printer to silently ignore the print command. The MQTT url field contained unencoded spaces the firmware couldn't parse. Fixed by replacing spaces with underscores in the remote filename.
  - Virtual Printer Proxy A1 Printing Fails (#757) — A1/P1S proxy mode failed because ports 2024-2026 weren't proxied.
  - H2D External Spool Print Fails (#797) — 0700_8012 "Failed to get AMS mapping table" when printing from external spool on H2D.
  - Spool Assignment on Empty AMS Slots (#784) — Assigning spools to truly empty slots created a stuck state. Also fixed stale slot data on H2D.
  - Log Flood: "State is FINISH but completion NOT triggered" (#790) — Diagnostic message fired on every MQTT update in FINISH/FAILED state, flooding logs in printer farms.
  - ffmpeg Process Leak Causing Memory Growth (#776) — Camera ffmpeg processes accumulated over time, consuming GB of RAM.
  - SpoolBuddy Updates Now Use SSH — Replaced fragile self-update with SSH-based updates driven by Bambuddy. Automatic key pairing, branch-aware, Force Update button.
  - SpoolBuddy Update Check Always Shows "Up to Date" — Was comparing against GitHub releases instead of backend version.
  - SpoolBuddy NFC Write Fails on NTAG Tags — Multiple PN5180 state machine and CRC issues prevented writing NTAG 213/215/216 tags.
  - SpoolBuddy Read Tag Diagnostic Fails on NTAG Tags — Five issues preventing NTAG reads in the diagnostic script.
  - SpoolBuddy Scale First Reading Always Wrong — NAU7802 ADC stale first reading polluted the moving average. Also extracted hardware drivers into proper modules.
  - SpoolBuddy Low Filament Warning Missing Slot Number — Showed "AMS B" instead of "B2".
  - SpoolBuddy Assign Spool Modal Clipping Display — Modal overflowed off-screen on the touchscreen.
  - SpoolBuddy Kiosk Starts Before Network Is Ready — Kiosk now waits for network-online.target.
  - SpoolBuddy Update UI Stale After Restart — Old version shown permanently after update.
  - Delete Tag Leaves Stale Tag Type — Only tag_uid was cleared, not tray_uuid/tag_type/data_origin.
  - Database Connection Pool Exhaustion on Large Printer Farms — Increased pool from 30 to 220 connections.
  - Frontend Not Updating After Deploy — Service worker served stale cached bundles.
  - Spoolman Sidebar Opens Root URL Instead of Spool Page — Now navigates to /spool.

  Contributors

  - @Keybored02 (#787, #789, #814)
  

(Upstream release: https://github.com/maziggy/bambuddy/releases/tag/v0.2.2.2)

## [0.2.2.1-0] - 2026-03-22

  # Bambuddy v0.2.2.1

  ## Virtual Printer — Breaking Changes

  ▎ Action required for existing Virtual Printer users. Please follow the migration guide before updating.

The Virtual Printer FTP server now binds directly to port 990 instead of using an iptables redirect from 990 → 9990. This fixes FTP being routed to the wrong VP when running multiple virtual printers on different bind IPs (#735).

  What you need to do:
  - Native/systemd: Remove old iptables redirect rules (990 → 9990) and verify CAP_NET_BIND_SERVICE is set in the systemd service.
  - Docker (bridge network): Change port mapping from 990:9990 to 990:990 in docker-compose.yml.
  - Docker (host network): Remove old iptables redirect rules on the host. No other changes needed.
  - Unraid/Synology/TrueNAS: Remove any iptables rules you added for 990 → 9990.

  Detailed instructions can be found here -> https://github.com/maziggy/bambuddy/blob/0.2.2.1/docs/migration-vp-ftp-port.md

  Proxy mode now supports cross-VLAN/subnet printing (#757) with transparent TCP proxying for FTP (990), file transfer (6000), and camera streaming (322). If you use proxy mode behind a firewall, ensure ports 6000 and 322 are open between the slicer and Bambuddy.

  X1C/X1 compatibility is fixed — both server mode (corrected SSDP model codes BL-P001/BL-P002) and proxy mode (end-to-end TLS passthrough preserving the printer's real certificate). Existing VPs are automatically migrated on startup.


  ## Highlights

  - Virtual Printer Overhaul (#735, #757) — Major rework of Virtual Printer networking. FTP, proxy mode, and X1C compatibility all significantly improved. Existing VP users: action required — see below.
  - Select Plates to Queue (#777) — Multi-plate 3MF files now support selecting a subset of plates to queue, with per-plate checkboxes.
  - HMS Error Visibility (#772) — Red "Problem" counter in the status bar, amber/red status pips, and HMS-first sorting for print farms.
  - Per-User Email Notifications (#693) — When Advanced Authentication is enabled, individual users can now receive email notifications for their own print jobs. Contributed by @cadtoolbox.
  - Spool Rotation During AMS Drying — Added a "Rotate spool during drying" checkbox to the manual drying popover for AMS 2 Pro and AMS-HT units.

  ## New Features

  - SpoolBuddy OTA Updates — SpoolBuddy devices can now be updated directly from the Settings → Updates tab without SSH access. Click "Check for Updates" to see if a newer version is available, then "Apply Update" to trigger the update. The daemon picks up the command via its heartbeat, pulls the latest code from GitHub, installs dependencies, and restarts automatically via systemd. Live progress is shown in the UI with status messages from the device. The status bar at the bottom automatically checks for updates every 5 minutes and shows a prominent message when one is available. Requires the device to be online.
  - Select Plates to Queue (#777) — Multi-plate 3MF files now support selecting a subset of plates to queue, instead of only "one plate" or "all plates". In add-to-queue mode, each plate has a checkbox for multi-select, with a "Select All / Deselect All" toggle. Reprint and edit modes remain single-select.
  - Camera Image Rotation (#672) — Added per-printer camera rotation (0°, 90°, 180°, 270°) for cameras mounted in portrait or upside-down orientations. Configurable in Settings → Camera for each printer. Rotation applies to live stream, embedded viewer, stream overlay, and notification snapshots.
  - Per-User Email Notifications (#693) — When Advanced Authentication is enabled, individual users can now receive email notifications for their own print jobs. Contributed by @cadtoolbox.
  - Quick Print Speed Control (#256) — Speed control badge on the printer card with Silent/Standard/Sport/Ludicrous presets.
  - Spool Name Column & Filter in Filament Inventory (#740) — Added a "Spool" column and spool name filter dropdown.
  - Spool Rotation During AMS Drying — Added a "Rotate spool during drying" checkbox to the manual drying popover for AMS 2 Pro and AMS-HT units.
  - Admin Set Default Nav-Menu Order (#761) — Admins can set their sidebar menu order as the default for new users. Contributed by @cadtoolbox.
  - Add Total Cost to Projects (#733) — Projects page now shows total cost (material + energy + BOM). Contributed by @Keybored02.
  - Material Mismatch & Insufficient Filament Checks (#720) — Warns on filament type/profile mismatch and insufficient material before printing. Contributed by @Keybored02.
  - Rework Archive Duplicates Tagging (#718) — Smarter duplicate detection (name + SHA256), reprint counter tags, parent print links. Contributed by @Keybored02.

  ## Improved

  - HMS Error Visibility on Printers Page (#772) — Red "Problem" counter in the status summary bar, red/amber status pips for errors/warnings, amber progress bars for paused prints, and HMS-first sorting.
  - Home Assistant Notifications (#750) — Added support for HA notify services. Contributed by @mrtncode.
  - Print Command Response Verification (#737) — Monitors whether the printer responds within 15 seconds after sending a print command; logs a warning if silently ignored.
  - Compact Assign Spool Modal (#725) — 3-column grid layout showing more spools without scrolling.
  - Reformatted AMS Drying Presets Table (#732) — Grouped by AMS type with inline unit labels.
  - Redesigned Bug Report Debug Log Flow — Interactive 3-step flow instead of a fixed 30-second timer.

  ## Fixed

  - Queue Print Command Not Reaching Printer (#778) — Fixed repeated MQTT reconnection cycles on printers that reject request topic subscription.
  - AMS Slot Search Shows Unrelated Profiles (#681) — Search filter now correctly applies to saved presets.
  - AMS Spools Removed After Printer Restart (#765) — Skips slot clearing on shutdown messages.
  - Carbon Rod Lubrication Maintenance Task Incorrect (#755) — Removed incorrect lubrication task for carbon rods.
  - Spurious "Job Waiting for Filament" Notification (#753) — Skips waiting notification when all printers are just busy.
  - File Rename Removes Extension (#751) — Extension is now non-editable.
  - Ntfy Notifications Fail With Non-ASCII Characters (#742) — Fixed UTF-8 encoding for header values.
  - Print Complete Notification Not Firing (#736) — Added 45-second timeout on photo capture.
  - Camera Window Overlapping Modals (#738) — Lowered camera z-index.
  - Webhook Notifications Missing Camera Snapshot (#679) — Added base64-encoded image field to webhook payloads.
  - White Filament Color Swatches Invisible in Light Theme (#726) — Changed to dark border across all views.
  - Mobile Sidebar Not Scrollable — Added overflow scrolling.
  - Send Bambu RFID Tags to Spoolman & Manual Mode Unlink (#719) — Proper RFID identifiers sent to Spoolman, unlink button in manual mode, fixed location clearing for generic spools. Contributed by @shrunbr.
  - SpoolBuddy Daemon Reports Stale Version — Version now read from backend APP_VERSION instead of hardcoded string.
  - Native Install Missing CAP_NET_BIND_SERVICE — Fixed systemd template for VP proxy on native installs.
  - UserEmailPreference Model Not Registered — Fixed SQLAlchemy model import order.

  ## Security

  - Bump pyOpenSSL 25.3.0 → 26.0.0 — Fixes CVE-2026-27448 and CVE-2026-27459.
  - Bump pyasn1 0.6.2 → 0.6.3 — Fixes CVE-2026-30922.
  - Bump flatted 3.4.1 → 3.4.2 — Fixes GHSA-rf6f-7fwh-wjgh (dev dependency).

  ## Contributors

  Thank you to everyone who contributed to this release!

  - @cadtoolbox — Admin default nav-menu order (#761), Per-user email notifications (#693)
  - @Keybored02 — Total cost in Projects (#733), Material mismatch checks (#720), Archive duplicates rework (#718)
  - @mrtncode — Home Assistant notify services (#750)
  - @shrunbr — Bambu RFID tags to Spoolman & manual unlink (#719)

  And thanks to everyone who reported issues and provided feedback!

(Upstream release: https://github.com/maziggy/bambuddy/releases/tag/v0.2.2.1)

## [0.2.2-0] - 2026-03-22

**# Bambuddy v0.2.2 final**

**## Highlights**
- **Remote AMS Drying** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Start, monitor, and stop drying sessions for AMS 2 Pro and AMS-HT directly from the Printers page. Select filament type with official BambuStudio temperature/duration presets, or set temperature manually. Supported on X1/X1C, P1P/P1S, H2D, H2D Pro, and X1E.
- **Queue Auto-Drying** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Automatically dry filament between scheduled queue prints when AMS humidity exceeds the configured threshold. Uses conservative parameters for mixed filament types, with optional "block queue" mode to delay prints until drying completes.
- **Ambient Drying** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Automatically keep filament dry on idle printers based on humidity, even without queued prints. Enable "Ambient drying" in Settings → Print Queue.
- **Virtual Printer Queue Auto-Dispatch Toggle** ([#587](https://github.com/maziggy/bambuddy/issues/587)) — Added an "Auto-dispatch" toggle to virtual printers in Queue mode. When disabled, prints are added to the queue but wait for manual dispatch instead of starting automatically.
- **Queue All Plates** ([#530](https://github.com/maziggy/bambuddy/issues/530)) — Multi-plate 3MF files can now be queued in one action. A "Queue All N Plates" toggle adds every plate as a separate queue entry, each individually editable.
- **AMS Info Card & Custom Labels** ([#570](https://github.com/maziggy/bambuddy/pull/570)) — Hovering an AMS label shows serial number, firmware version, and an editable friendly name. Slot numbers now display inside each filament color circle. Contributed by @cadtoolbox.
- **In-App Bug Reporting** — A floating bug report button lets users submit reports directly from the UI, including description, optional screenshot, and automatically collected diagnostic data with full sensitive-data redaction.

**## New Features**

- **First Layer Complete Notification** ([#679](https://github.com/maziggy/bambuddy/issues/679)) — Get notified with a camera snapshot when the first layer finishes printing, so you can check adhesion remotely. Enable the "First Layer Complete" toggle on any notification provider.
- **Remote AMS Drying** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Start, monitor, and stop drying sessions for AMS 2 Pro and AMS-HT directly from the Printers page. Select filament type with official BambuStudio temperature/duration presets, or set temperature manually. Supported on X1/X1C, P1P/P1S, H2D, H2D Pro, and X1E.
- **Queue Auto-Drying** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Automatically dry filament between scheduled queue prints when AMS humidity exceeds the configured threshold. Uses conservative parameters for mixed filament types, with optional "block queue" mode to delay prints until drying completes.
- **Configurable Drying Presets** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Customize temperature and duration for each filament type in Settings → Print Queue. Defaults match BambuStudio presets, with separate presets for AMS 2 Pro and AMS-HT.
- **AMS PSU Detection** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — The drying button is disabled with a tooltip when the AMS lacks sufficient power for drying. Reads `dry_sf_reason` from firmware and surfaces HMS error codes for power issues.
- **Ambient Drying** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — Automatically keep filament dry on idle printers based on humidity, even without queued prints. Enable "Ambient drying" in Settings → Print Queue.
- **Assign Spool to Empty AMS Slot** ([#717](https://github.com/maziggy/bambuddy/issues/717)) — The "Assign Spool" option now appears on empty (unconfigured) AMS slots. Selecting a spool auto-configures the slot with the correct filament profile, color, and K-profile in one step.
- **Home Assistant Notification Provider** ([#656](https://github.com/maziggy/bambuddy/issues/656)) — Send persistent notifications to the HA dashboard. HA automations can forward them to mobile apps, WhatsApp, or any other service.
- **Virtual Printer Queue Auto-Dispatch Toggle** ([#587](https://github.com/maziggy/bambuddy/issues/587)) — Added an "Auto-dispatch" toggle to virtual printers in Queue mode. When disabled, prints are added to the queue but wait for manual dispatch instead of starting automatically.
- **Queue All Plates** ([#530](https://github.com/maziggy/bambuddy/issues/530)) — Multi-plate 3MF files can now be queued in one action. A "Queue All N Plates" toggle adds every plate as a separate queue entry, each individually editable.
- **Malaysian Ringgit Currency** ([#634](https://github.com/maziggy/bambuddy/issues/634)) — Added MYR (RM) to the list of supported currencies for filament cost tracking.
- **ETA Variable in Notifications** ([#638](https://github.com/maziggy/bambuddy/issues/638)) — Added `{eta}` template variable to print start/progress notifications. Shows estimated wall-clock completion time based on the user's configured time format (12h/24h).
- **Bulk Delete Spool and Color Catalog Entries** ([#646](https://github.com/maziggy/bambuddy/issues/646)) — Added checkbox selection and bulk delete to both the Spool Catalog and Color Catalog in Settings > Filament.
- **Force Color Match** ([#625](https://github.com/maziggy/bambuddy/pull/625)) — Added a "Force Color Match" option for "Print to Any" queue scheduling, requiring strict color matching when assigning prints to printers. Contributed by @cadtoolbox.
- **Israeli New Shekel Currency** — Added ILS to the list of supported currencies for filament cost tracking.
- **AMS Info Card & Custom Labels** ([#570](https://github.com/maziggy/bambuddy/pull/570)) — Hovering an AMS label shows serial number, firmware version, and an editable friendly name. Slot numbers now display inside each filament color circle. Contributed by @cadtoolbox.
- **In-App Bug Reporting** — A floating bug report button lets users submit reports directly from the UI, including description, optional screenshot, and automatically collected diagnostic data with full sensitive-data redaction.
- **SpoolBuddy NFC Tag Writing (OpenTag3D)** — Write NFC tags for third-party filament spools using the OpenTag3D format on NTAG213/215/216 stickers. Supports writing for existing spools, creating new spools, or replacing damaged tags.
- **SpoolBuddy On-Screen Keyboard** — Added a virtual QWERTY keyboard for the SpoolBuddy kiosk UI since the Raspberry Pi has no physical keyboard. Auto-shows when text inputs are focused.
- **SpoolBuddy Inline Spool Cards** — Placing an NFC-tagged spool on the reader now shows spool info directly in the dashboard panel instead of a modal overlay, with action buttons for AMS assignment, weight sync, and more.
- **SpoolBuddy AMS Page: External Slots & Slot Configuration** — The SpoolBuddy AMS page now displays external spool slots and AMS-HT units. Clicking any slot opens the configuration modal for filament type and color.
- **SpoolBuddy Dashboard Redesign** — Redesigned with a two-column layout showing device connection status and printer badges on the left, spool card on the right. Removed the separate inventory page in favor of main Bambuddy UI.
- **SpoolBuddy Kiosk Auth Bypass via API Key** — The `/auth/me` endpoint now accepts API keys, and the install script includes the API key in the kiosk URL for automatic authentication on boot.
- **Daily Beta Builds** — Added a release script for daily multi-arch Docker beta builds pushed to GHCR and Docker Hub. Beta images are never tagged as `latest`.
- **Inventory Scale Weight Check Column** — Added a "Weight Check" column (hidden by default) to the inventory table that compares each spool's last scale measurement against its calculated gross weight.

**## Fixed**

- **Library Upload Doesn't Show New File Until Page Reload** ([#704](https://github.com/maziggy/bambuddy/issues/704)) — The upload endpoint used `db.flush()` instead of `db.commit()`, so the file list was stale until page reload. Fixed the same race condition in folder create/update and file update endpoints.
- **Printer File Manager Doesn't Auto-Refresh** ([#704](https://github.com/maziggy/bambuddy/issues/704)) — The printer SD card browser only fetched files once when opened. Now auto-refreshes every 30 seconds.
- **Database Connection Pool Exhaustion Under Load** ([#704](https://github.com/maziggy/bambuddy/issues/704)) — Background tasks held database sessions during slow network I/O, exhausting the pool. Doubled the pool to 30 connections.
- **Block Mode Skips Humidity Auto-Stop** ([#292](https://github.com/maziggy/bambuddy/issues/292)) — When "Wait for drying to complete" was enabled, drying sessions that reached humidity target continued indefinitely. Block mode now only prevents starting new drying, not stopping completed sessions.
- **AMS Fill Level Shows 0% for Non-Viewer Users** ([#676](https://github.com/maziggy/bambuddy/issues/676)) — Stale inventory fill of 0% permanently shadowed the correct real-time AMS remain value due to nullish coalescing not falling through on `0`. Now bypasses inventory when it says 0% but AMS hardware reports positive remain.
- **Virtual Printer Proxy Mode Always Shows X1C Model** — Now auto-inherits the model from the target printer when creating or updating a proxy virtual printer.
- **Cloud Profiles Shared Across All Users** ([#665](https://github.com/maziggy/bambuddy/issues/665)) — Bambu Cloud credentials were stored globally instead of per-user. Each user now logs into their own Cloud account independently. Also fixed cloud endpoints requiring wrong permissions.
- **Local Profiles Not Shown in AMS Slot Configuration** — The `compatible_printers` filter parsed JSON as semicolon-delimited, silently skipping all local presets. Removed the filter entirely.
- **Interface Aliases Not Shown in Virtual Printer Interface Select** — Interface aliases (e.g. `eth0:1`) were invisible because the Docker image lacked `iproute2`. Added it to the image.
- **P2S Camera Stream Disconnects After a Few Seconds** ([#661](https://github.com/maziggy/bambuddy/issues/661)) — GnuTLS rejected TLS behaviors some printer firmwares rely on. Added a local TLS termination proxy using OpenSSL. Also reduced reconnect delay and fixed choppy external camera streams.
- **iOS/iPadOS Cannot Reposition Floating Camera** ([#687](https://github.com/maziggy/bambuddy/issues/687)) — The floating camera viewer only handled mouse events. Added touch event support for drag and resize.
- **PA-CF / PA12-CF / PAHT-CF Not Treated as Compatible** ([#688](https://github.com/maziggy/bambuddy/issues/688)) — Added a filament type equivalence system so PA variants are treated as compatible in scheduler assignment, AMS slot matching, and filament override dropdowns.
- **Force Color Match Toggle Click Target Too Large** ([#688](https://github.com/maziggy/bambuddy/issues/688)) — The click target now covers only the checkbox, icon, and label text instead of the entire row.
- **HA Switch Badge Always Sends Turn On Instead of Toggle** — Now sends `toggle` for non-script entities so the badge click actually toggles the switch state.
- **Multiple Plugs Per Printer Crashes Auto-On/Off** — `scalar_one_or_none()` raised `MultipleResultsFound` when multiple smart plugs were assigned. Now fetches all plugs and returns the main power plug.
- **Multiple HA Switches Per Printer UNIQUE Constraint** — The migration to remove the UNIQUE constraint on `smart_plugs.printer_id` now uses regex matching and also checks standalone UNIQUE indexes.
- **HMS Notifications for Unknown/Phantom Error Codes** — Flipped notification logic from "notify all, suppress specific" to "only notify for errors with known descriptions", matching the frontend behavior.
- **Ethernet Badge Shown on WiFi Printers / MQTT Disconnecting** ([#585](https://github.com/maziggy/bambuddy/issues/585)) — Three bugs: wrong detection method (bit 18 vs wifi_signal heuristic), bad import path crashing MQTT thread, and WiFi-only models not excluded.
- **Inventory Usage Tracker Missing External Spool Mapping** ([#677](https://github.com/maziggy/bambuddy/issues/677)) — Fallback `slot_id - 1` could never reach external spool IDs. Added position-based resolution using sorted available tray IDs. Contributed by @shrunbr.
- **Spool Assignment Applies Wrong Filament Profile** ([#681](https://github.com/maziggy/bambuddy/issues/681)) — Cloud API returns only the base `filament_id` for versioned setting IDs, ignoring variants. Added a cross-check that corrects the filament ID via reverse lookup.
- **Debug Logging Endpoint 500 Error** — Duration calculation mixed timezone-aware and naive datetimes. Now strips timezone info when reading stored timestamps.
- **Bed Cooled Notification Never Fires** ([#497](https://github.com/maziggy/bambuddy/issues/497)) — Partial MQTT updates didn't include `bed_temper`, so cached temperature never dropped. The monitor now sends periodic `pushall` commands to force fresh data.
- **Notification Provider Missing Event Toggles on Create** ([#497](https://github.com/maziggy/bambuddy/issues/497)) — The create endpoint omitted 8 event toggles (`on_bed_cooled` and 7 queue events), so they always defaulted to false regardless of user selection.
- **Clear Plate Prompt Shown for Staged Queue Items** — The prompt now only appears when there are auto-dispatchable items that the scheduler will actually start.
- **Ethernet Badge Shown on WiFi-Only Printers** ([#585](https://github.com/maziggy/bambuddy/issues/585)) — WiFi-only models (A1, P1P, etc.) are now excluded via model-based gating.
- **GitHub Backup Required Cloud Login** ([#655](https://github.com/maziggy/bambuddy/issues/655)) — Removed the cloud auth gate so GitHub backup can be configured and used without Bambu Cloud login.
- **GitHub Backup Log Timestamps Off by 1 Hour** — Timestamps were displayed in UTC instead of the user's local timezone. Now uses `parseUTCDate` for correct conversion.
- **H2D AMS Units Shown on Wrong Nozzle** ([#659](https://github.com/maziggy/bambuddy/issues/659)) — Three bugs in AMS `info` field parsing: decimal instead of hex, wrong bit extraction, and partial updates overwriting full map. All fixed.
- **SD Card Error After FTP Upload** ([#645](https://github.com/maziggy/bambuddy/issues/645)) — The FTP upload skipped the server's 226 "Transfer complete" response, sending the print command before the file was flushed to disk. Now waits for confirmation.
- **P2S Shows Carbon Rod Maintenance Tasks** ([#640](https://github.com/maziggy/bambuddy/issues/640)) — The P2S uses steel shafts, not carbon rods. Added a new `steel_rod` category with appropriate maintenance tasks.
- **Dispatch Toast Stuck After Second Print** — The dedup guard was never reset between batches, leaving the progress toast stuck. Now resets on dismiss and new batch start.
- **Archive Card Buttons Overlapping at Narrow Widths** ([#641](https://github.com/maziggy/bambuddy/issues/641)) — Buttons now clip cleanly with ellipsis instead of overlapping at narrow viewport widths.
- **Debug Logging Banner Timer Shows Negative Time** — Mixed local/UTC timestamps caused negative duration display. Now stores and compares all timestamps in UTC.
- **Non-Bambu Lab Spools Can't Link/Unlink to Spoolman** ([#653](https://github.com/maziggy/bambuddy/pull/653)) — Generates a fallback tag from printer/AMS/tray IDs for spools without RFID identifiers. Also added an "Unlink" button. Contributed by @shrunbr.
- **Spoolman Location Not Updated on Link/Unlink** ([#669](https://github.com/maziggy/bambuddy/pull/669)) — Linking now sets the Spoolman location to printer name, AMS name, and slot number; unlinking clears it. Contributed by @shrunbr.
- **Print Dispatch Toast Disappears Instantly on Fast Uploads** ([#615](https://github.com/maziggy/bambuddy/issues/615)) — The dispatch toast now stays visible for 3 seconds after completion showing a success message before auto-dismissing.
- **Print Modal Shows Busy Printers as Selectable** ([#622](https://github.com/maziggy/bambuddy/issues/622)) — The printer selector now shows live state badges and grays out busy printers in reprint mode. Queue mode still allows selecting busy printers.
- **PWA Install Not Available in Chrome** ([#629](https://github.com/maziggy/bambuddy/issues/629)) — Fixed incorrect icon dimensions, split the `"any maskable"` purpose, and added required screenshots to the manifest.
- **Project Statistics Count Archived Files as Printed** ([#630](https://github.com/maziggy/bambuddy/issues/630)) — Only files with `status="completed"` (actually printed) now count toward completion stats, excluding archived files.
- **Python 3.10 Compatibility** — Added a compatibility shim for `enum.StrEnum` which was added in Python 3.11.
- **Bug Report Bubble Overlapping Toasts** — Moved toast notifications and upload progress above the bug report bubble.
- **Virtual Printer: Bind-TLS Proxy Handshake Failure on OpenSSL 3.x** — Added RSA key exchange ciphers to the client SSL context for compatibility with Bambu printers.
- **Windows: Server Shuts Down After 60 Seconds** ([#605](https://github.com/maziggy/bambuddy/issues/605)) — ffmpeg cleanup broadcast `CTRL_C_EVENT` to the entire process group. Now spawns ffmpeg in its own process group.
- **Multi-Printer Filament Mapping Shows Wrong Nozzle Filaments on Dual-Nozzle Printers** ([#624](https://github.com/maziggy/bambuddy/issues/624)) — The multi-printer filament mapping path was missing the `nozzle_id` filter that the single-printer path already had.
- **Filament Mapping Dropdowns Missing Subtypes** ([#624](https://github.com/maziggy/bambuddy/issues/624)) — Now shows `tray_sub_brands` (e.g. "PLA Basic", "PLA Matte") in all filament dropdowns, with separate dedup entries for different subtypes.
- **Archive Card Shows "Source" Badge for Sliced .3mf Files** — Now checks `total_layers` and `print_time_seconds` metadata to determine if a `.3mf` file is sliced. Also passes the original filename when creating archives.
- **AMS Slot Shows Wrong Material for "Support for" Profiles** — The name parser returned the first material match ("PLA") instead of the one after "Support for" ("PETG"). Both frontend and backend parsers now detect the naming pattern.
- **Firmware Check Shows Wrong Version for H2D Pro** ([#584](https://github.com/maziggy/bambuddy/issues/584)) — Added all known SSDP model codes to the firmware check mapping so raw device codes resolve to the correct firmware track.
- **Spurious Error Notifications During Normal Printing (0300_0002)** — HMS error codes with low 16 bits below `0x4000` are status indicators, not faults. Now skips them in both parsers.
- **Spool Auto-Assign Fails With Greenlet Error** ([#612](https://github.com/maziggy/bambuddy/issues/612)) — SQLAlchemy lazy-loaded `spool.assignments` outside the async greenlet. Now initializes the collection on new spools and eagerly loads it for existing ones.
- **SpoolBuddy Link Tag Missing tag_type** — Now uses the dedicated `linkTagToSpool` endpoint with proper `tag_type` and `data_origin` values.
- **SpoolBuddy AMS Page Missing Fill Levels for Non-BL Spools** — Now fetches inventory assignments and computes fill levels from weight data, falling back to AMS remain when no assignment exists.
- **SpoolBuddy AMS Page Ext-R Slot Falsely Shown as Active When Idle** — Guards against `tray_now=255` (idle sentinel) before ext slot active check.
- **Printer Card Loses Info When Print Is Paused** ([#562](https://github.com/maziggy/bambuddy/issues/562)) — Print progress info now shows for both `RUNNING` and `PAUSE` states. Status label correctly reads "Paused".
- **SpoolBuddy "Assign to AMS" Slot Shows Empty Fields in Slicer** — Fixed version suffix handling in cloud API calls, correct `filament_id` resolution, and `SlotPresetMapping` saving.
- **Virtual Printer Bind Server Fails With TLS-Enabled Slicers** ([#559](https://github.com/maziggy/bambuddy/issues/559)) — Port 3002 now uses TLS for slicer compatibility, while port 3000 remains plain TCP.
- **Queue Returns 500 When Cancelled Print Exists** ([#558](https://github.com/maziggy/bambuddy/issues/558)) — Normalizes `"aborted"` status to `"cancelled"` before storing. A startup fixup converts existing bad rows.
- **Tests Send Real Maintenance Notifications** — Tests now cancel spawned background tasks before mock context exits.
- **Virtual Printer Config Changes Ignored Until Toggle Off/On** — `sync_from_db()` now compares critical fields and restarts VPs when config changes are detected.
- **Sidebar Navigation Ignores User Permissions** — Each nav item is now hidden when the user lacks the corresponding read permission. Also added missing `inventory:*` permissions to the frontend type definition.
- **Camera Button Clickable Without Permission & ffmpeg Process Leak** ([#550](https://github.com/maziggy/bambuddy/issues/550)) — Camera button now requires `camera:view` permission. Added proper process cleanup with background disconnect monitoring and periodic orphan scanning.
- **Windows Install Fails With "Syntax of the Command Is Incorrect"** ([#544](https://github.com/maziggy/bambuddy/issues/544)) — Removed redundant hash verification block that used unparseable multi-line `for /f` syntax.
- **Queue Badge Shows on Incompatible Printers** ([#486](https://github.com/maziggy/bambuddy/issues/486)) — The badge count now applies the same filament compatibility filter as the queue widget.
- **SpoolBuddy Daemon Can't Find Hardware Drivers** — Added `scripts/` to `sys.path` at daemon startup and moved imports inside try/except blocks. Demoted hardware-not-available logs to INFO.
- **SpoolBuddy Scale Tare & Calibration Not Applied** — Fixed five bugs in the tare/calibration chain including missing API endpoints, stale values overwriting new ones, and self-referential factor computation.
- **A1 Mini Shows "Unknown" Status After MQTT Payload Decode Failure** ([#549](https://github.com/maziggy/bambuddy/issues/549)) — Non-UTF-8 MQTT payloads now fall back to `decode(errors="replace")` instead of being silently dropped.
- **H2C Dual Nozzle Variant (O1C2) Not Recognized** ([#489](https://github.com/maziggy/bambuddy/issues/489)) — Added `O1C2` to all model ID maps across backend and frontend, fixing camera protocol, display names, and more.
- **Support Package Leaks Full Subnet IPs and Misdetects Docker Network Mode** — Masks subnet octets, correctly detects Docker network mode, and parses `fun` field from top-level MQTT payload.
- **SpoolBuddy Scale Calibration Lost After Reboot** — Device ID generation now sorts network interfaces alphabetically for deterministic selection across reboots.
- **SpoolBuddy NFC Reader Fails to Detect Tags** — Fixed PN5180 polling state corruption with full hardware reset before each idle poll, and RF cycle before each active poll. Added auto-recovery after consecutive errors.

**## Improved**

- **Shorter Inventory Location Labels** — Location column now shows compact labels like "H2D-1 B3" instead of "H2D-1 AMS-B Slot 3".
- **Higher FTP Timeout Options for Large Files** ([#660](https://github.com/maziggy/bambuddy/issues/660)) — Added 180s and 300s FTP timeout options. The previous 120s max was insufficient for large 3MF files during active printing.
- **Separate Permission for AMS Spool Assignments** ([#635](https://github.com/maziggy/bambuddy/issues/635)) — New `inventory:view_assignments` permission lets users see AMS spool assignments without accessing the full Inventory page.
- **Prometheus Build Info Metric** ([#633](https://github.com/maziggy/bambuddy/pull/633)) — Added `bambuddy_build_info` gauge metric exposing version, Python version, platform, and architecture. Contributed by @sw1nn.
- **i18n: Settings, Smart Plugs, Notifications, Backup/Restore** — Replaced all hardcoded English strings with translation keys across Settings, Smart Plug, Notification, and Backup/Restore components. Added ~600 new keys to all 7 locales.
- **Install Script: Branch Selection** — The native install script now supports a `--branch` option and interactive branch prompt for beta testers.
- **Print Queue Scheduler Diagnostics** ([#616](https://github.com/maziggy/bambuddy/issues/616)) — Added diagnostic logging showing skip summaries and per-printer state details to help diagnose why queued prints aren't starting.
- **SpoolBuddy Settings Page Redesign** — Redesigned with a tabbed layout (Device, Display, Scale, Updates) including brightness slider, screen blank timeout, step-indicator calibration wizard, and update checker.
- **SpoolBuddy Language & Time Format Support** — The kiosk now respects Bambuddy's configured UI language and time format, with full translations for all 6 languages.
- **SpoolBuddy Kiosk Stability** — Disabled swipe-to-navigate gesture and added `video` group for DSI backlight access.
- **SpoolBuddy Touch-Friendly UI** — Enlarged all interactive elements across the kiosk UI for comfortable finger use on the 1024×600 touchscreen, meeting 44px minimum tap targets.
- **Ethernet Connection Indicator** ([#585](https://github.com/maziggy/bambuddy/issues/585)) — Printers on ethernet now show a green "Ethernet" badge with cable icon instead of WiFi signal strength.
- **SpoolBuddy AMS Page Single-Slot Card Layout** — AMS-HT and external spool cards now use a responsive grid aligned with regular AMS card columns.
- **SpoolBuddy Scale Value Stabilization** — Suppresses redundant scale reports (only sends on ≥2g change), increased moving average window, and added frontend 3g display threshold.
- **SpoolBuddy TopBar: Online Printer Selection** — Printer selector now only shows online printers and auto-selects the first available. Auto-switches if selected printer goes offline.
- **SpoolBuddy Assign to AMS Redesign** — Full-screen overlay reusing AMS page components with one-click slot assignment via a single API call.
- **Filament ID Conversion Utility** — Extracted filament_id/setting_id conversion into a shared utility. The `assign_spool` endpoint now correctly sends both `tray_info_idx` and `setting_id`.
- **Updates Card Separates Firmware and Software Settings** — Split into labeled "Printer Firmware" and "Bambuddy Software" sections.
- **SpoolBuddy Test Coverage** — Added 21 backend integration tests and 20 frontend component tests covering all SpoolBuddy API endpoints and main components.
- **Cleanup Obsolete Settings** — Startup migration now deletes orphaned settings keys no longer used by the application.
- **Added HUF Currency** ([#579](https://github.com/maziggy/bambuddy/issues/579)) — Added Hungarian Forint (HUF, Ft) to supported currencies.
- **FTP Upload Progress & Speed** — Reduced chunk size from 1MB to 64KB for smoother progress reporting. Removed post-upload wait that caused 30+ second hangs on H2D. Added transfer speed logging.
- **Wider Print & Schedule Modals** — Increased modal width from 512px to 672px to accommodate long filament profile names.

**## Changed**

- **CI: Node.js 20 → 22** — Updated GitHub Actions workflows to Node.js 22 LTS ahead of GitHub's Node 20 deprecation.
- **Daily Builds Falsely Trigger Update Notification** — The version parser misclassified daily build tags as full releases. Now strips the daily suffix before parsing.
- **License changed from MIT to AGPL-3.0** — To prevent unauthorized redistribution of Bambuddy as a closed-source product. Community contributions and usage are unaffected.

**## Security**

- **Stored XSS via Project Notes** — Project notes rendered with `dangerouslySetInnerHTML` without sanitization. Now sanitized with DOMPurify.
- **Stored XSS via 3MF Description (Sanitizer Bypass)** — Hand-rolled HTML sanitizer allowed attribute injection via quote break-out. Replaced with DOMPurify.
- **Unauthenticated Auth Toggle via Setup Endpoint** — The `/api/v1/auth/setup` endpoint could disable authentication without being authenticated. Now returns 403 when auth is already enabled.
- **PyJWT ≥2.12.0** — Bumped minimum version to address CVE-2026-32597.
- **flatted ≥3.4.0** — Updated transitive ESLint dependency to address GHSA-25h7-pfq9-p65f (unbounded recursion DoS).
- **Access Code Redacted from Support Logs** — Printer access codes in RTSP URLs were not redacted in support bundles. Extended sanitizer to cover `rtsps://` URLs and added access codes to exact-match redaction.

**## Merged Pull Requests**

- [#508](https://github.com/maziggy/bambuddy/pull/508) — feat(queue): show spool grams left in filament slot mapping (@cimdDev)
- [#531](https://github.com/maziggy/bambuddy/pull/531) — Add customizable low stock threshold, add low stock filter (@Keybored02)
- [#561](https://github.com/maziggy/bambuddy/pull/561) — Statistics page: timeframe filtering, new widgets & fix success rate (@aneopsy)
- [#569](https://github.com/maziggy/bambuddy/pull/569) — Printer Page: print button & drop zone on printer card (@aneopsy)
- [#570](https://github.com/maziggy/bambuddy/pull/570) — Feature AMS Info Card (@cadtoolbox)
- [#573](https://github.com/maziggy/bambuddy/pull/573) — Add energy cost to archive card (@Keybored02)
- [#578](https://github.com/maziggy/bambuddy/pull/578) — Fix AMS slot modal infinite scroll loop on Windows (@aneopsy)
- [#580](https://github.com/maziggy/bambuddy/pull/580) — Fix AMS slot modal infinite scroll loop on Windows (@aneopsy)
- [#581](https://github.com/maziggy/bambuddy/pull/581) — Refactor frontend utility functions to reduce duplication (@aneopsy)
- [#625](https://github.com/maziggy/bambuddy/pull/625) — Feature: Force Color Match (@cadtoolbox)
- [#627](https://github.com/maziggy/bambuddy/pull/627) — Sync i18n locales: add 655 translated keys, remove 127 stale keys (@aneopsy)
- [#633](https://github.com/maziggy/bambuddy/pull/633) — feat(metrics): add bambuddy_build_info metric (@sw1nn)
- [#653](https://github.com/maziggy/bambuddy/pull/653) — Non-Bambu Lab Spools: fully link/unlink to Spoolman (@shrunbr)
- [#669](https://github.com/maziggy/bambuddy/pull/669) — Update Spoolman location when linking/unlinking (@shrunbr)
- [#686](https://github.com/maziggy/bambuddy/pull/686) — Properly track filament usage data in Spoolman (@shrunbr)
- [#700](https://github.com/maziggy/bambuddy/pull/700) — Allow SMTP to be configured before auth is enabled (@shrunbr)
- [#710](https://github.com/maziggy/bambuddy/pull/710) — SMTP testing uses saved database settings (@shrunbr)
- [#711](https://github.com/maziggy/bambuddy/pull/711) — Ensures AMS-HT devices are properly identified in Spoolman (@shrunbr)

**## Community Contributors**

- **@shrunbr** — Spoolman integration improvements: non-Bambu spool linking/unlinking, location updates, filament usage tracking, AMS-HT identification, SMTP configuration and testing fixes.
- **@aneopsy** — Statistics page enhancements with timeframe filtering and new widgets, printer card print button and drop zone, AMS slot modal scroll fix, frontend utility refactoring, i18n locale sync, and print dispatch toast fix.
- **@cadtoolbox** — AMS Info Card with custom labels and slot numbers, Force Color Match for queue scheduling, and multiple bug reports for AMS/permission/ethernet issues.
- **@Keybored02** — Customizable low stock threshold with filter, and energy cost display on archive cards.
- **@cimdDev** — Spool grams remaining display in queue filament slot mapping.
- **@sw1nn** — Prometheus `bambuddy_build_info` metric for version tracking and alerting.

(Upstream release: https://github.com/maziggy/bambuddy/releases/tag/v0.2.2)

<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

# Changelog

All notable changes to the App will be documented in this file.

## [0.2.2-0] - 2026-03-21

- Bump bambuddy to 0.2.2

## [0.1.8.1-1] - 2026-02-07

- Bump bambuddy to 0.1.8.1

## [0.1.8-1] - 2026-02-06

- Bump bambuddy to 0.1.8
- Remove copied README & DOCS