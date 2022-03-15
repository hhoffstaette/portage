# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils user go-module

DESCRIPTION="APC UPS statistics exporter for Prometheus"
HOMEPAGE="https://github.com/mdlayher/apcupsd_exporter"
KEYWORDS="amd64"
LICENSE="MIT"
SLOT="0"
IUSE=""

SRC_URI="https://github.com/mdlayher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	# first build the library
	ego build
	# then build the actual executable
	cd cmd/${PN}
	ego build
}

src_install() {
	dobin ${S}/cmd/${PN}/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

