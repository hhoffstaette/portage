# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="prometheus monitoring system and time series database"
HOMEPAGE="https://prometheus.io"
MY_PN=${PN%%-bin}
MY_P=${MY_PN}-${PV}
SRC_URI="https://github.com/prometheus/prometheus/releases/download/v${PV}/${MY_P}.linux-amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

QA_PREBUILT=".*"
RESTRICT="mirror"

DEPEND="acct-group/prometheus
	acct-user/prometheus
	!app-metrics/prometheus"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}.linux-amd64"

src_install() {
	dobin prometheus promtool
	insinto /etc/prometheus
	doins prometheus.yml

	systemd_dounit "${FILESDIR}"/prometheus.service
	newinitd "${FILESDIR}"/prometheus.initd prometheus
	newconfd "${FILESDIR}"/prometheus.confd prometheus
	keepdir /var/log/prometheus /var/lib/prometheus
	fowners prometheus:prometheus /var/log/prometheus /var/lib/prometheus
}
