# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="https://github.com/prometheus/alertmanager/releases/download/v${PV}/alertmanager-${PV}.linux-amd64.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# tests don't work due to "missing files"
RESTRICT+=" mirror test"

DEPEND="
	acct-group/alertmanager
	acct-user/alertmanager
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/alertmanager-${PV}.linux-amd64"

src_install() {
	dobin alertmanager amtool
	dodoc LICENSE NOTICE
	insinto /etc/alertmanager/
	newins alertmanager.yml config.yml
	keepdir /var/lib/alertmanager /var/log/alertmanager
	systemd_dounit "${FILESDIR}"/alertmanager.service
	newinitd "${FILESDIR}"/alertmanager.initd alertmanager
	newconfd "${FILESDIR}"/alertmanager.confd alertmanager
	fowners alertmanager:alertmanager /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
}
