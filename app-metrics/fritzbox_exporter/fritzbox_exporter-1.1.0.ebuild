# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Fritz!Box Upnp statistics exporter for Prometheus"
HOMEPAGE="https://github.com/ndecker/fritzbox_exporter"

SRC_URI="https://github.com/ndecker/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64"

DEPEND="acct-group/fritzbox_exporter
	acct-user/fritzbox_exporter"

src_compile() {
	cd "${S}"
	ego build
}

src_install() {
	dobin fritzbox_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
