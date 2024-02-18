# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Anti-spam bayesian filter"
HOMEPAGE="http://getpopfile.org"
SRC_URI="http://getpopfile.org/downloads/${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cjk ipv6 mysql ssl xmlrpc"

RDEPEND="virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	dev-perl/DBD-SQLite
	dev-perl/HTML-Tagset
	dev-perl/HTML-Template
	dev-perl/TimeDate
	dev-perl/DBI
	virtual/perl-Digest
	cjk? ( dev-perl/Encode-compat
		dev-perl/Text-Kakasi )
	mysql? ( dev-perl/DBD-mysql	)
	ipv6? ( dev-perl/IO-Socket-INET6 )
	ssl? ( dev-libs/openssl
		dev-perl/IO-Socket-SSL
		dev-perl/Net-SSLeay )
	xmlrpc? ( dev-perl/PlRPC )"

BDEPEND="app-arch/unzip"

PATCHES=(
	# increase select timeout
	"${FILESDIR}"/${P}-select-timeout.patch
)

src_prepare() {
	default

	# patch templates for relative URLs
	local f
	for f in $(find skins -name "*.thtml"); do
		sed -i -e s/'action\=\"\/'/'action\=\"'/g \
			-e s/'href\=\"\/'/'href\=\"'/g \
			-e s/'src\=\"\/'/'src\=\"'/g $f
	done
}

src_install() {
	dodoc *.change*
	rm -rf *.change* license || die

	insinto /usr/share/${PN}
	doins -r * || die

	fperms 755 /usr/share/${PN}/{popfile,insert,pipe,bayes}.pl

	keepdir /var/spool/${PN}
	dosym /var/spool/${PN} /usr/share/${PN}/data

	newinitd "${FILESDIR}"/popfile.init popfile || die
}
