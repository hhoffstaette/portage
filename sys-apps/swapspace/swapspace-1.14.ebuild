# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="A dynamic swap space manager"
HOMEPAGE="https://github.com/Tookmund/Swapspace"
SRC_URI="https://github.com/Tookmund/Swapspace/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 x86"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/prefix.patch")

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "Make failed!"
}

src_install() {
	newconfd "${FILESDIR}/swapspace.confd" ${PN}
	newinitd "${FILESDIR}/swapspace.initd" ${PN}

	dosbin "${S}"/src/swapspace

	insinto /etc
	doins swapspace.conf

	doman "${S}"/doc/doc/swapspace.8

	dodoc COPYING README
}
