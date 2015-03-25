
EAPI=5

DESCRIPTION="Shows per-process swap usage."
HOMEPAGE="https://github.com/hhoffstaette/swapusage"
SRC_URI="https://github.com/hhoffstaette/swapusage/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2"
KEYWORDS="amd64 x86"

src_compile() {
	emake || die "build failed."
}

src_install() {
    dobin swapusage
}
