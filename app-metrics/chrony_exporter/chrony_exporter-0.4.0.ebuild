# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Chrony NTP exporter for Prometheus"
HOMEPAGE="https://github.com/SuperQ/chrony_exporter"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="acct-group/chrony_exporter
		acct-user/chrony_exporter"

SRC_URI="https://github.com/SuperQ/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

src_compile() {
	ego build
}

src_install() {
	dobin ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

