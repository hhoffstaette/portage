# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Export Nomad statistics to Prometheus"
HOMEPAGE="https://github.com/pcarranza/nomad-exporter"
SRC_URI="https://github.com/pcarranza/${PN}/releases/download/${PV}/nomad-exporter_${PV}_linux_amd64.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
KEYWORDS="amd64"
SLOT="0"
IUSE=""

S=${WORKDIR}
DOCS=( README.md )

pkg_setup() {
	enewgroup nomad-exporter
	enewuser nomad-exporter -1 -1 -1 nomad-exporter
}

src_install() {
	dobin nomad-exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -o nomad-exporter -g nomad-exporter -m 0750
	keepdir /var/log/nomad-exporter
}
