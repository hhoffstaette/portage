# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Chrony NTP exporter for Prometheus"
HOMEPAGE="https://github.com/SuperQ/chrony_exporter"

SRC_URI="https://github.com/SuperQ/chrony_exporter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-golang-dist/chrony_exporter/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

DEPEND="acct-group/chrony_exporter
		acct-user/chrony_exporter"

BDEPEND="
	>=dev-lang/go-1.25.0
	dev-util/promu
"


src_prepare() {
	default

	if ! use static; then
		eapply "${FILESDIR}/0.13.3-promu-config.patch"
	fi

	# No need to enable the race detector for tests (#935442)
	sed -i -e '/test-flags := -race/d' Makefile.common || die
}

src_compile() {
	promu build -v || die
}

src_install() {
	newbin ${P} ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
