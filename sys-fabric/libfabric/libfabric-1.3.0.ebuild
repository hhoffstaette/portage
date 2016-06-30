# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="User-space RDMA Fabric Interfaces"
HOMEPAGE="http://ofiwg.github.io/libfabric/"
SRC_URI="https://github.com/ofiwg/libfabric/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# TODO: need to actually test building with IB providers
# IUSE="-psm -verbs"
# DEPEND="psm? ( sys-fabric/infinipath-psm )
#	verbs? ( sys-fabric/libibverbs )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/libfabric-${PV}"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	./autogen.sh
}

src_configure() {
	CFLAGS="${CFLAGS}" econf \
		--prefix=/usr
		# $(use_enable psm) \
		# $(use_enable verbs)
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
