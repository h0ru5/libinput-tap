#!/usr/bin/env bash
# Follow Arch's libinput version. Rebases our patch if needed; fails loudly if it no longer applies.
set -euo pipefail
cd "$(dirname "$0")"
want=$(curl -fsSL https://gitlab.archlinux.org/archlinux/packaging/packages/libinput/-/raw/main/PKGBUILD | sed -n 's/^pkgver=//p')
have=$(sed -n 's/^pkgver=//p' PKGBUILD)
[ "$want" = "$have" ] && { echo "up to date ($have)"; exit 0; }
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 --branch "$want" https://gitlab.freedesktop.org/libinput/libinput.git "$tmp/src"
git -C "$tmp/src" apply --check "$PWD"/0001-*.patch || { echo "patch no longer applies to $want, rebase it" >&2; exit 1; }
sed -i "s/^pkgver=.*/pkgver=$want/; s/^pkgrel=.*/pkgrel=1/" PKGBUILD
echo "bumped $have -> $want"
