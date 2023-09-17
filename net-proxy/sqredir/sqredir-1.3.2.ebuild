# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A correct, small, fast and easy to use Squid URL rewriter"
HOMEPAGE="https://github.com/hhoffstaette/sqredir"
SRC_URI="https://github.com/hhoffstaette/sqredir/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

DEPEND=">=dev-libs/libpcre-8.33"
RDEPEND="${DEPEND}"

src_configure() {
	CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS} cmake CMakeLists.txt
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	dobin ${PN} || die
	insinto /etc
	doins sqredir.conf || die
}

