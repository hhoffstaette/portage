
EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="ObjFW is a portable, lightweight framework for the Objective-C language."
HOMEPAGE="https://webkeks.org/objfw/"
SRC_URI="https://webkeks.org/objfw/downloads/${P}.tar.xz"
LICENSE="|| ( GPL-2 GPL-3 QPL )"
SLOT="0"
KEYWORDS="~x86"
IUSE="clang"
DEPEND="clang? ( >=sys-devel/clang-3.2 )"
        
src_unpack() {
	unpack ${A}
}

src_configure() {
	OBJCFLAGS=${CFLAGS}

	if use clang; then
		OBJC="clang"
		OBJCFLAGS+=" -Qunused-arguments"
	fi

	econf OBJC="${OBJC}" OBJCFLAGS="${OBJCFLAGS}" || die "configure failed"
}

src_compile() {
	emake src || die "make failed"
}

test_compile() {
	emake tests || die "tests failed"
}

src_install() {
	# Skipping tests does not seem to work with the install target
	einstall DONT_RUN_TESTS=1 || die
}

