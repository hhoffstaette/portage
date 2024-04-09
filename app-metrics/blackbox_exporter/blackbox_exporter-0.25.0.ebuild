# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module systemd

DESCRIPTION="Prometheus exporter for blackbox probing via HTTP, HTTPS, DNS, TCP and ICMP"
HOMEPAGE="https://github.com/prometheus/blackbox_exporter"

SRC_URI="https://github.com/prometheus/blackbox_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

GIT_COMMIT=ef3ff4fef195333fb8ee0039fb487b2f5007908f

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"

KEYWORDS="amd64 arm64"

COMMON_DEPEND="
	acct-group/blackbox_exporter
	acct-user/blackbox_exporter"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"
BDEPEND="dev-util/promu"

FILECAPS=(
	cap_net_raw usr/bin/blackbox_exporter
)

# tests require the network
RESTRICT+=" mirror test "

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/Head/" \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		-e "s/{{.Version}}/${PV}/" .promu.yml || die
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	newbin bin/${P} ${PN}
	dodoc {README,CHANGELOG,CONFIGURATION}.md blackbox.yml
	insinto /etc/blackbox_exporter
	newins example.yml blackbox.yml
	keepdir /var/lib/blackbox_exporter /var/log/blackbox_exporter
	fowners ${PN}:${PN} /var/lib/blackbox_exporter /var/log/blackbox_exporter
	systemd_dounit "${FILESDIR}"/blackbox_exporter.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
