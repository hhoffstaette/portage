# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Minimize caching effects for applications"
HOMEPAGE="https://github.com/Feh/nocache"
SRC_URI="https://github.com/Feh/nocache/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-sync-minsize.patch
)

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "Make failed!"
}

src_install() {
	# wat: the .so must be colocated with the nocache script..
	dobin ${PN} ${PN}.so cachestats cachedel || die
	doman man/${PN}.1 man/cachestats.1 man/cachedel.1 || die
}
