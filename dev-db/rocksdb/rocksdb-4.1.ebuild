# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A library that provides an embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org"
SRC_URI="https://github.com/facebook/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO java support is currently broken/wrong
# IUSE="-java"

RDEPEND="
	app-arch/bzip2
	app-arch/snappy
	dev-cpp/gflags
	sys-libs/zlib
"
# TODO add to RDEPEND later
#	java? ( virtual/jdk )

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${P}"

src_compile() {
	emake EXTRA_CXXFLAGS="-Wno-error=unused-variable" shared_lib

# TODO
#	if use java ; then
#		emake rocksdbjavastatic
#	fi
}

src_install() {
	emake INSTALL_PATH="${D}/usr" install
	dodoc README.md

# TODO
#	if use java ; then
#		insinto /usr/lib/${PN}
#		doins java/target/rocksdbjni-${PV}-linux$(getconf LONG_BIT).jar
#	fi
}
