
EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="A correct, small, fast and easy to use Squid URL rewriter"
HOMEPAGE="https://github.com/hhoffstaette/sqredir"
SRC_URI="https://github.com/hhoffstaette/sqredir/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="${DEPEND}"

src_configure() {
	CFLAGS=${CFLAGS} cmake CMakeLists.txt
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	dobin ${PN} || die
	insinto /etc
	doins sqredir.conf || die
}
