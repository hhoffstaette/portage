# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A dynamic swap space manager"
HOMEPAGE="https://github.com/Tookmund/Swapspace"
SRC_URI="https://github.com/Tookmund/Swapspace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-${PV}-config.patch"
	"${FILESDIR}/${PN}-${PV}-wakeup-interval.patch"
)

S="$WORKDIR"/Swapspace-${PV}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	default
	econf --localstatedir=/var --sysconfdir=/etc
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
