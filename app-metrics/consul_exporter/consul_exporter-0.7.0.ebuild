# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user

DESCRIPTION="Prometheus exporter for consul metrics"
HOMEPAGE="https://github.com/prometheus/consul_exporter"
SRC_URI="https://github.com/prometheus/consul_exporter/releases/download/v${PV}/${P}.linux-amd64.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
RESTRICT+=" test"

S="${WORKDIR}/${P}.linux-amd64"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	newbin ${PN} ${PN}
	dodoc {LICENSE,NOTICE}
	keepdir /var/log/consul_exporter
	fowners ${PN}:${PN} /var/log/consul_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
