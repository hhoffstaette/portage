# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="https://github.com/prometheus/${PN}/releases/download/v${PV}/node_exporter-${PV}.linux-amd64.tar.gz"
RESTRICT="mirror"
KEYWORDS="amd64"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

S=${WORKDIR}/${P}.linux-amd64

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	dobin node_exporter
	dodoc LICENSE NOTICE
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter
	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
