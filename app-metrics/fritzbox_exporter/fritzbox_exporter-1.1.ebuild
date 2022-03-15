# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils user go-module

KEYWORDS="amd64"

DESCRIPTION="Fritz!Box Upnp statistics exporter for Prometheus"
HOMEPAGE="https://github.com/hhoffstaette/fritzbox_exporter"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

SRC_URI="https://github.com/hhoffstaette/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	cd ${S}
	ego build
}

src_install() {
	dobin fritzbox_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

