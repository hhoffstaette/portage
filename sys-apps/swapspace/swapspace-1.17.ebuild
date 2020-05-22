# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils flag-o-matic

DESCRIPTION="A dynamic swap space manager"
HOMEPAGE="https://github.com/Tookmund/Swapspace"
SRC_URI="https://github.com/Tookmund/Swapspace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 x86"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/config.patch")

S="$WORKDIR"/Swapspace-${PV}

src_configure() {
	default
	eautoreconf && econf --localstatedir=/var --sysconfdir=/etc
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "Make failed!"
}

src_install() {
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	dosbin "${S}"/src/${PN}

	insinto /etc
	doins ${PN}.conf

	doman "${S}"/doc/${PN}.8
	dodoc COPYING README

	keepdir /var/lib/${PN}
}
