# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

GIT_COMMIT=2f0cff51fd1cc761eeb671db43736341ca2ab511
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="https://github.com/prometheus/alertmanager/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 arm64"

# tests don't work due to "missing files"
RESTRICT+=" mirror test"

BDEPEND="dev-util/promu"

DEPEND="
	acct-group/alertmanager
	acct-user/alertmanager"
	RDEPEND="${DEPEND}"

src_prepare() {
	default

	# use our git commit
	sed -i -e "s/{{.Revision}}/${GIT_COMMIT}/" .promu.yml || die
}

src_compile() {
	promu build --cgo -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CHANGELOG}.md
	insinto /etc/alertmanager/
	newins doc/examples/simple.yml config.yml
	keepdir /var/lib/alertmanager /var/log/alertmanager
	systemd_dounit "${FILESDIR}"/alertmanager.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	fowners ${PN}:${PN} /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
}
