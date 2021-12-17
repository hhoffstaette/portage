# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

KEYWORDS="amd64"
DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"
SRC_URI="https://releases.hashicorp.com/consul/${PV}/${PN}_${PV}_linux_amd64.zip"

SLOT="0"
LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT"
IUSE=""

RESTRICT="test"

DEPEND="
	acct-group/consul
	acct-user/consul"

RDEPEND=""

S=${WORKDIR}

src_install() {
	local x

	strip consul
	dobin consul

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"
}
