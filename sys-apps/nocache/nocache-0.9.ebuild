
EAPI=4

inherit eutils flag-o-matic

DESCRIPTION="Minimize caching effects for applications"
HOMEPAGE="https://github.com/Feh/nocache"
SRC_URI="https://github.com/Feh/nocache/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="${DEPEND}"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "Make failed!"
}

src_install() {
	# wat: the .so must be colocated with the nocache script..
	dobin ${PN} ${PN}.so cachestats cachedel || die
	doman man/${PN}.1 man/cachestats.1 man/cachedel.1 || die
}
