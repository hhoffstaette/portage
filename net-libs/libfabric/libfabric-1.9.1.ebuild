# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic

DESCRIPTION="User-space RDMA Fabric Interfaces"
HOMEPAGE="http://ofiwg.github.io/libfabric/"
SRC_URI="https://github.com/ofiwg/libfabric/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64"
IUSE="usnic verbs"

DEPEND="verbs? ( sys-cluster/rdma-core )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/libfabric-${PV}"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default
	./autogen.sh
}

src_configure() {
	CFLAGS="${CFLAGS}" econf --prefix=/usr \
		--disable-dependency-tracking \
		$(use_enable usnic) \
		$(use_enable verbs)
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}

