
EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="A correct, small, fast and easy to use Squid URL rewriter"
HOMEPAGE="https://github.com/hhoffstaette/sqredir"
SRC_URI="https://github.com/hhoffstaette/sqredir/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=dev-libs/libpcre-8.33"
RDEPEND="${DEPEND}"

src_configure() {
	CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS} cmake CMakeLists.txt
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	dobin ${PN} || die
	insinto /etc
	doins sqredir.conf || die
}

