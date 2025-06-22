# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="APC UPS statistics exporter for Prometheus"
HOMEPAGE="https://github.com/mdlayher/apcupsd_exporter"

SRC_URI="https://github.com/mdlayher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

DEPEND="acct-group/apcupsd_exporter
		acct-user/apcupsd_exporter"

RESTRICT="!test? ( test )"

src_compile() {
	# the binary resides in the cmd subdirectory
	cd cmd/${PN} || die
	ego build
}

src_test() {
	# tests need to be run from the build root
	ego test
}

src_install() {
	dobin "${S}"/cmd/${PN}/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
