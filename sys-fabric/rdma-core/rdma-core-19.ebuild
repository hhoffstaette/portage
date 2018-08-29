# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev

DESCRIPTION="RDMA core userspace libraries and daemons"
HOMEPAGE="https://github.com/linux-rdma/rdma-core"
# MUST use the correct artifact or installation will fail due to missing prebuilt manpages.
SRC_URI="https://github.com/linux-rdma/${PN}/releases/download/v${PV}/${P}.tar.gz"
KEYWORDS="amd64 x86"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"
IUSE=""

DEPEND="!sys-fabric/libibverbs"
RDEPEND="${DEPEND}
	sys-apps/ethtool"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_RUNDIR="${EPREFIX}"/run
		-DCMAKE_INSTALL_SHAREDSTATEDIR="${EPREFIX}"/var/lib
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_UDEV_RULESDIR="$(get_udevdir)"/rules.d
	)

	cmake-utils_src_configure
}

