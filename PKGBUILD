# Arch's libinput plus one patch: AttrTapMoveThreshold quirk.
# Based on the official libinput PKGBUILD. update.sh follows its version.
pkgbase=libinput-tap
pkgname=(libinput-tap libinput-tools-tap)
_upname=libinput
pkgver=1.32.0
pkgrel=1
pkgdesc="libinput with a configurable tap move threshold (AttrTapMoveThreshold quirk)"
url="https://github.com/h0ru5/libinput-tap"
arch=(x86_64)
license=(MIT)
depends=(glibc libevdev libgcc libwacom lua54 mtdev systemd-libs)
makedepends=(cairo git glib2 gtk4 libx11 meson python python-libevdev
             python-pyudev python-yaml wayland wayland-protocols)
source=("git+https://gitlab.freedesktop.org/libinput/libinput.git?signed#tag=$pkgver"
        0001-touchpad-add-AttrTapMoveThreshold-quirk.patch)
b2sums=('SKIP' 'SKIP')
validpgpkeys=(3C2C43D9447D5938EF4551EBE23B7E70B467F0BF) # Peter Hutterer

prepare() {
  git -C $_upname apply ../0001-touchpad-add-AttrTapMoveThreshold-quirk.patch
}

build() {
  arch-meson $_upname build -D documentation=false -D tests=false
  meson compile -C build
}

_pick() {
  local p="$1" f d; shift
  for f; do
    d="$srcdir/$p/${f#$pkgdir/}"
    mkdir -p "$(dirname "$d")"
    mv "$f" "$d"
    rmdir -p --ignore-fail-on-non-empty "$(dirname "$f")"
  done
}

package_libinput-tap() {
  # keep libinput.so in sync with the official package (pacman -Qi libinput)
  provides=("libinput=$pkgver" libinput.so=10-64)
  conflicts=(libinput)
  meson install -C build --destdir "$pkgdir"
  (cd "$pkgdir"; _pick tools usr/bin; _pick tools usr/lib/libinput; _pick tools usr/share/man; _pick tools usr/share/zsh)
  install -Dm644 $_upname/COPYING -t "$pkgdir/usr/share/licenses/$pkgname"
}

package_libinput-tools-tap() {
  pkgdesc+=" (debug utilities)"
  depends=(cairo glib2 glibc gtk4 libevdev libgcc libinput-tap libx11 python
           python-libevdev python-pyudev python-yaml systemd-libs wayland)
  provides=("libinput-tools=$pkgver")
  conflicts=(libinput-tools)
  mv tools/* "$pkgdir"
  install -Dm644 $_upname/COPYING -t "$pkgdir/usr/share/licenses/$pkgname"
}
