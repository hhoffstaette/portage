# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user

EGO_PN="github.com/prometheus/prometheus"
KEYWORDS="amd64"
PLATFORM="linux-amd64"

DESCRIPTION="Prometheus monitoring system and time series database"
HOMEPAGE="https://github.com/prometheus/prometheus"

SRC_URI="https://github.com/prometheus/prometheus/releases/download/v${PV}/${P}.${PLATFORM}.tar.gz"
LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="test"

PROMETHEUS_HOME="/var/lib/prometheus"

pkg_setup() {
	enewgroup prometheus
	enewuser prometheus -1 -1 "${PROMETHEUS_HOME}" prometheus
}

S=${WORKDIR}/${P}.${PLATFORM}

src_install() {
	dobin prometheus promtool tsdb
	dodoc -r LICENSE NOTICE
	insinto /etc/prometheus
	doins prometheus.yml
	insinto /usr/share/prometheus
	doins -r console_libraries consoles
	dosym ../../usr/share/prometheus/console_libraries /etc/prometheus/console_libraries
	dosym ../../usr/share/prometheus/consoles /etc/prometheus/consoles

	newinitd "${FILESDIR}"/prometheus.initd prometheus
	newconfd "${FILESDIR}"/prometheus.confd prometheus
	keepdir /var/log/prometheus /var/lib/prometheus
	fowners prometheus:prometheus /var/log/prometheus /var/lib/prometheus
}

