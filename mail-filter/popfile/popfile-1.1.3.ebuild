# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Anti-spam bayesian filter"
HOMEPAGE="http://getpopfile.org"
SRC_URI="http://getpopfile.org/downloads/${P}.zip"

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

DEPEND="app-arch/unzip"

PATCHES=(
	# increase select timeout
	"${FILESDIR}"/${P}-select-timeout.patch
)

S="${WORKDIR}"

src_prepare() {
	default
    # patch templates for relative URLs
	local f
	for f in `find skins -name "*.thtml"`
	do
		sed s/'action\=\"\/'/'action\=\"'/g $f > $f.tmp1
		sed s/'href\=\"\/'/'href\=\"'/g $f.tmp1 > $f.tmp2
		sed s/'src\=\"\/'/'src\=\"'/g $f.tmp2 > $f
		rm -f $f.tmp1 $f.tmp2
	done
}

src_install() {
	dodoc *.change*
	rm -rf *.change* license

	insinto /usr/share/${PN}
	doins -r * || die

	fperms 755 /usr/share/${PN}/{popfile,insert,pipe,bayes}.pl

	keepdir /var/spool/${PN}
	dosym /var/spool/${PN} /usr/share/${PN}/data

	newinitd ${FILESDIR}/popfile.init popfile || die
}
