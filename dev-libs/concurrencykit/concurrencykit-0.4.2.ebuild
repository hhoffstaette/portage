
EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="Concurrency primitives for high performance concurrent systems"
HOMEPAGE="http://concurrencykit.org/"
SRC_URI="https://github.com/concurrencykit/ck/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pointer-packing rtm"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/ck-${PV}"
}

src_configure() {
	if use pointer-packing ; then
		O_PP="--enable-pointer-packing"
	fi

	if use rtm ; then
		O_RTM="--enable-rtm"
	fi
	
	CFLAGS="${CFLAGS}" econf --prefix=/usr ${O_PP} ${O_RTM} || die "configure failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}

