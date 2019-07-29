# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}_${PV}_linux_amd64.tgz"
KEYWORDS="amd64"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="logrotate"
RESTRICT="test"

S=${WORKDIR}

src_install() {
	dobin ${S}/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /etc
	doins "${FILESDIR}"/${PN}.conf

	if use logrotate ; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotated" ${PN}
	fi
}

pkg_postinst() {
	elog
	elog A minimal configuration to act as caching forwarding server
	elog has been installed as /etc/coredns.conf - please review it
	elog before starting CoreDNS.
	elog
	elog For more information see https://coredns.io/manual/toc/
	elog
}

