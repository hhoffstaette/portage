# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user golang-build golang-vcs-snapshot

KEYWORDS="amd64"
EGO_PN=github.com/mdlayher/${PN}
EGIT_COMMIT="a060e981103aef458fbc5c7a11f0de70762984bf"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="APC UPS statistics exporter for Prometheus"
HOMEPAGE="https://github.com/mdlayher/apcupsd_exporter"
LICENSE="MIT"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	cd ${S}/src/${EGO_PN}
	default
}

src_compile() {
	cd ${S}/src/${EGO_PN}
	default
	# first build the library
	GOPATH="${S}" go build
	# also compile the actual executable
	cd cmd/${PN}
	GOPATH="${S}" go build
}

src_install() {
	dobin ${S}/src/${EGO_PN}/cmd/${PN}/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

