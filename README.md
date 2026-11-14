# libinput-tap

Arch's `libinput` plus one patch: a new `AttrTapMoveThreshold` quirk.

libinput treats a touch as a tap only if the finger moves 1.3mm or less. If your finger slides a bit
on lift-off (motor impairments, for example), many taps become pointer motion. This patch makes the
limit configurable per device, in mm. Default is unchanged (1.3).

```
# /etc/libinput/local-overrides.quirks
[My trackpad]
MatchVendor=0x05AC
MatchProduct=0x0265
AttrTapMoveThreshold=2.5
```

## Install (Arch)

```
makepkg -f
sudo pacman -U --ask 4 libinput-tap-*.pkg.tar.zst libinput-tools-tap-*.pkg.tar.zst
```

It provides and conflicts with `libinput` / `libinput-tools`. Roll back with `sudo pacman -S libinput libinput-tools`.
Log out and back in afterwards so the compositor loads the new library.

## Staying in sync

`update.sh` follows the version in Arch's PKGBUILD. A weekly workflow runs it and opens a PR; it fails
if the patch stops applying. Upstream proposal: see the libinput merge request linked in issues.
