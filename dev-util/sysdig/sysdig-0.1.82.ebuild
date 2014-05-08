# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils linux-mod

DESCRIPTION="An system-level exploration and troubleshooting tool. "
HOMEPAGE="http://github.com/draios/sysdig http://www.sysdig.org/"
SRC_URI="http://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/jsoncpp
	dev-lang/luajit
	sys-libs/zlib"

RDEPEND=$DEPEND

ARCH="x86"
BUNDLED_DEPS="-DUSE_BUNDLED_JSONCPP=OFF -DUSE_BUNDLED_LUAJIT=OFF -DUSE_BUNDLED_ZLIB=OFF"
PREFIX="-DCMAKE_INSTALL_PREFIX=/usr"

pkg_setup() {
	CONFIG_CHECK="MODULES"
	linux-mod_pkg_setup
	BUILD_TARGETS="all"
	BUILD_PARAMS="KERNEL_BUILD=${KERNEL_DIR}"
}

src_configure() {
	mkdir build && cd build
	CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS} cmake ${PREFIX} ${BUNDLED_DEPS}  ..
}

src_compile() {
	cd build && make ARCH=${ARCH} ${MAKEOPTS}
}

src_install() {
	cd build
	# sysdig
	dobin userspace/sysdig/sysdig
	# man page
	doman ../userspace/sysdig/man/sysdig.8
	# chisels
	dodir /usr/share/sysdig/chisels
	cp userspace/sysdig/chisels/*.lua ${D}/usr/share/sysdig/chisels
	# kernel module
	MODULE_NAMES="sysdig-probe(misc:${WORKDIR}/${PF}/driver)"
	linux-mod_src_install
}
