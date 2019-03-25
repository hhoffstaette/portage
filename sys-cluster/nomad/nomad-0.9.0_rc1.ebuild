# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user versionator

KEYWORDS="amd64"
DESCRIPTION="The cluster manager from Hashicorp"
HOMEPAGE="http://www.nomadproject.io"
MY_PV=$(replace_version_separator 3 '-' )
SRC_URI="https://releases.hashicorp.com/${PN}/${MY_PV}/${PN}_${MY_PV}_linux_amd64.zip"

SLOT="0"
LICENSE="MPL-2.0"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

pkg_setup() {
	enewgroup ${PN}
	enewuser  ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_install() {
	local dir

	dobin "${S}/${PN}"

	for dir in /var/{lib,log}/${PN}; do
		keepdir "${dir}"
		fowners ${PN}:${PN} "${dir}"
	done

	keepdir /etc/nomad.d
	insinto /etc/nomad.d

	doins "${FILESDIR}/"data-dir.json
	doins "${FILESDIR}/"client.json.example
	doins "${FILESDIR}/"server.json.example

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}

pkg_postinst() {
	elog
	elog "Sample configurations have been installed in /etc/nomad.d/."
	elog "Please rename either the client or server configuration for the"
	elog "desired role; acting as both client and server is possible"
	elog "and useful for testing (e.g. on a single host), but not recommended"
	elog "for production."
	elog ""
	elog "For more information see https://www.nomadproject.io/docs/configuration/."
	elog
}
