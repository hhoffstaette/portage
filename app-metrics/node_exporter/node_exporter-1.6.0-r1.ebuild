# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

MY_PV="v${PV/_rc/-rc.}"

NODE_EXPORTER_COMMIT=ff7f9d69b645cb691dd3e84dc3afc88f5c006962

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
RESTRICT="mirror"

SRC_URI="https://github.com/prometheus/node_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
		https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

CDEPEND="acct-group/node_exporter
	acct-user/node_exporter"
DEPEND=">=dev-util/promu-0.3.0
	${CDEPEND}"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}-${PV/_rc/-rc.}"

PATCHES=(
	"${FILESDIR}"/${PV}-btrfs-close-fds.patch
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
