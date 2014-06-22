
EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="Modern HTTP benchmarking tool"
HOMEPAGE="https://github.com/wg/wrk"
SRC_URI="https://github.com/wg/wrk/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC
	emake -j1 CFLAGS="${CFLAGS} -std=gnu99 -Wall -Wno-implicit-function-declaration -D_REENTRANT" || die "Make failed!"
}

src_install() {
	dobin ${PN} || die
}
