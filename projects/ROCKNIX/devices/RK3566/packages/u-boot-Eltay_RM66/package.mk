# SPDX-License-Identifier: GPL-2.0

PKG_NAME="u-boot-Eltay_RM66"
PKG_VERSION="v2026.10"
PKG_SHA256="f943a88389c8fd70a6b0d061a88267465e143c7ca6ea2b75837ab20f5b60c739"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/u-boot/u-boot"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl:host Python3:host swig:host pyelftools:host rkbin-Eltay_RM66"
PKG_DEPENDS_UNPACK="rkbin-Eltay_RM66"
PKG_TOOLCHAIN="manual"

make_target() {
  local rkbin_dir="$(get_build_dir rkbin-Eltay_RM66)/rk35"
  local -a host_make_args=(
    "HOSTCC=${HOST_CC}"
    "HOSTCFLAGS=-I${TOOLCHAIN}/include"
    "HOSTLDFLAGS=${HOST_LDFLAGS}"
  )

  setup_pkg_config_host
  export CROSS_COMPILE="${TARGET_KERNEL_PREFIX}"
  export ARCH=arm64
  export LDFLAGS=""

  make "${host_make_args[@]}" mrproper
  make "${host_make_args[@]}" eltay-rm66-rk3566_defconfig
  _python_sysroot="${TOOLCHAIN}" _python_prefix=/ _python_exec_prefix=/ \
    make "${host_make_args[@]}" BL31="${rkbin_dir}/rk3568_bl31_v1.44.elf" \
      ROCKCHIP_TPL="${rkbin_dir}/rk3566_ddr_1056MHz_v1.21.bin" \
      HOSTSTRIP=true CONFIG_MKIMAGE_DTC_PATH=scripts/dtc/dtc

  cp u-boot-rockchip.bin uboot.bin
}

makeinstall_target() {
  : # nothing
}
