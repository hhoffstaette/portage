
inherit eutils flag-o-matic

DESCRIPTION="Fast, secure and complete C string library"
HOMEPAGE="http://www.and.org/vstr/"
SRC_URI="ftp://ftp.and.org/pub/james/vstr/${PV}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_unpack() {
	unpack ${A}
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	einstall || die
}

