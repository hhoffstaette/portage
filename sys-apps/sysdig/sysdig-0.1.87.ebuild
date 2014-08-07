# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils linux-mod

DESCRIPTION="A system-level exploration and troubleshooting tool. "
HOMEPAGE="http://github.com/draios/sysdig http://www.sysdig.org/"
SRC_URI="http://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion -bundled-libs zsh-completion"

DEPEND="dev-libs/jsoncpp
	dev-lang/luajit
	sys-libs/zlib"

RDEPEND=$DEPEND

# needed for the kernel module
ARCH="x86"

# needed for cmake
PREFIX="/usr"

# prefer system dependencies by default
BUNDLED_LIBS="-DUSE_BUNDLED_JSONCPP=OFF -DUSE_BUNDLED_LUAJIT=OFF -DUSE_BUNDLED_ZLIB=OFF"

pkg_setup() {
	CONFIG_CHECK="MODULES"
	linux-mod_pkg_setup
	BUILD_TARGETS="all"
	BUILD_PARAMS="KERNEL_BUILD=${KERNEL_DIR}"
}

src_prepare() {
	epatch_user
}

src_configure() {
	mkdir build && cd build
	use bundled-libs && BUNDLED_LIBS=""
	CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS} cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} ${BUNDLED_LIBS}  ..
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

	# bash/zsh completions
	if use bash-completion; then
		dodir /usr/share/bash-completion
		cp ../scripts/completions/bash/sysdig ${D}/usr/share/bash-completion
	fi
	if use zsh-completion; then
		dodir /usr/share/zsh/site-functions
		cp ../scripts/completions/zsh/_sysdig ${D}/usr/share/zsh/site-functions
	fi

	# kernel module
	MODULE_NAMES="sysdig-probe(misc:${WORKDIR}/${PF}/driver)"
	linux-mod_src_install
}
