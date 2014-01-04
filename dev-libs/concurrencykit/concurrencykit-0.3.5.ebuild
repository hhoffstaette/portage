
EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="Concurrency primitives for high performance concurrent systems"
HOMEPAGE="http://concurrencykit.org/"
SRC_URI="http://concurrencykit.org/releases/ck-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/ck-${PV}"
}

src_configure() {	
	CFLAGS="${CFLAGS}" ./configure --prefix=/usr || die "configure failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}

