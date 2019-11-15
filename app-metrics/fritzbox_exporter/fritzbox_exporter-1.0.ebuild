# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user golang-build golang-vcs-snapshot

KEYWORDS="amd64"
EGIT_COMMIT="v${PV}"
EGO_PN=github.com/ndecker/${PN}
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fritz!Box Upnp statistics exporter for Prometheus"
HOMEPAGE="https://github.com/ndecker/fritzbox_exporter"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	cd ${S}/src/${EGO_PN}
	default
	epatch "${FILESDIR}"/add-send-receive-rates.patch
}

src_install() {
	strip fritzbox_exporter
	dobin fritzbox_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

