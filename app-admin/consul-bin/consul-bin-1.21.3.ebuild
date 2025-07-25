# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"

MY_PN="${PN/-bin/}"
SRC_URI="https://releases.hashicorp.com/consul/${PV}/${MY_PN}_${PV}_linux_amd64.zip"
S=${WORKDIR}

LICENSE="BUSL-1.1"
SLOT="0"
KEYWORDS="amd64"
RESTRICT+=" test"

BDEPEND="app-arch/unzip"

DEPEND="
	acct-group/consul
	acct-user/consul"

RDEPEND="!app-admin/consul"

src_install() {
	local x

	dobin consul

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example

	for x in /var/{lib,log}/${MY_PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	newinitd "${FILESDIR}/consul.initd" "${MY_PN}"
	newconfd "${FILESDIR}/consul.confd" "${MY_PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotated" "${MY_PN}"
	systemd_dounit "${FILESDIR}/consul.service"
}
