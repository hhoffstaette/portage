# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="Linux-native io_uring I/O access library"
HOMEPAGE="https://github.com/axboe/liburing"
SRC_URI="https://github.com/axboe/liburing/archive/${P}.tar.gz"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64"
SLOT="0"
IUSE="static-libs"

RDEPEND="${DEPEND}"

# slightly confused tarball content
S="${WORKDIR}/${PN}-${P}"

src_configure() {
	./configure --libdir=/usr/$(get_libdir) --mandir=/usr/share/man
}

src_compile() {
    emake -C src CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"  || die "Make failed!"
}

src_install() {
	default
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
	dodoc COPYING
}

