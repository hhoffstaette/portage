# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/alertmanager"
MY_PV="v${PV/_rc/-rc.}"
ARCHIVE_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
ALERTMANAGER_COMMIT="4c6c03e"

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="${ARCHIVE_URI}"
KEYWORDS="amd64"
LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.11
	dev-util/promu"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${ALERTMANAGER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GO111MODULE=on GOPATH="${S}" GOCACHE="${T}/go-cache" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	strip bin/*
	dobin bin/*
	dodoc {README,CHANGELOG,MAINTAINERS}.md
	insinto /etc/alertmanager/
	newins doc/examples/simple.yml config.yml.example
	popd || die
	keepdir /var/lib/alertmanager /var/log/alertmanager
	fowners ${PN}:${PN} /var/lib/alertmanager /var/log/alertmanager
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
