# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

MY_PV="v${PV/_rc/-rc.}"

NODE_EXPORTER_COMMIT=7333465abf9efba81876303bb57e6fadb946041b

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
RESTRICT="mirror"

SRC_URI="https://github.com/prometheus/node_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
		https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 arm64"

CDEPEND="acct-group/node_exporter
	acct-user/node_exporter"
BDEPEND=">=dev-util/promu-0.3.0
	${CDEPEND}"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}-${PV/_rc/-rc.}"

PATCHES=(
)

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" .promu.yml || die
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" .promu-cgo.yml || die
}

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix node_exporter || die
}

src_install() {
	dosbin node_exporter/node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	systemd_dounit "${FILESDIR}"/node_exporter.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter
}
