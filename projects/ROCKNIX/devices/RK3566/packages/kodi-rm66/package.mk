# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="kodi-rm66"
PKG_VERSION="11.0.105"
PKG_SHA256="61119b446113f39f4247350514cc5d6c2b1d08a6df3fc7bc990abdad949d4759"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://kodi.tv"
PKG_URL="https://mirrors.kodi.tv/addons/piers/resource.language.ru_ru/resource.language.ru_ru-${PKG_VERSION}.zip"
PKG_SOURCE_DIR="resource.language.ru_ru"
PKG_DEPENDS_TARGET="toolchain kodi peripheral.joystick rocknix"
PKG_ARCH="aarch64"
PKG_TOOLCHAIN="manual"
PKG_LONGDESC="Kodi integration and Russian language for ELTAY RM66"

makeinstall_target() {
  install -Dm0755 "${PKG_DIR}/rocknix-kodi" "${INSTALL}/usr/bin/rocknix-kodi"
  local addon="${INSTALL}/usr/share/kodi/addons/resource.language.ru_ru"
  mkdir -p "${addon}"
  cp -a addon.xml icon.png resources "${addon}/"
}

post_install() {
  local units="${INSTALL}/usr/lib/systemd/system"
  local manifest="${INSTALL}/usr/share/kodi/system/addon-manifest.xml"

  ln -sfn rocknix.target "${units}/default.target"
  find "${units}" -type l -lname '../kodi*.service' -delete
  ln -sfn /etc/ssl/certs/ca-certificates.crt "${INSTALL}/usr/share/kodi/system/certs/cacert.pem"
  xmlstarlet ed -L \
    -d '/addons/addon[text()="peripheral.joystick"]/@optional' \
    -d '/addons/addon[text()="repository.libreelec.tv"]' \
    -s '/addons' -t elem -n addon -v resource.language.ru_ru "${manifest}"
}
