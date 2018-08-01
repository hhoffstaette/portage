
EAPI=7

DESCRIPTION="Jitterentropy RNGd"
HOMEPAGE="https://github.com/smuellerDD/jitterentropy-rngd"
SRC_URI="https://github.com/smuellerDD/jitterentropy-rngd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
RDEPEND="${DEPEND}"

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	exeinto /usr/libexec
	doexe ${PN}
	doman ${PN}.1
	dodoc CHANGES COPYING README.md
	newinitd "${FILESDIR}/jitterentropy-rngd.initd" ${PN} || die
}
