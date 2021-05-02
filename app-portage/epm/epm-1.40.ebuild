# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit prefix

DESCRIPTION="rpm workalike for Gentoo Linux"
HOMEPAGE="https://github.com/hhoffstaette/epm"
SRC_URI="https://github.com/hhoffstaette/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-prefix.patch
	"${FILESDIR}"/${P}-layout.patch
)

src_prepare() {
	default
	eprefixify epm
}

src_compile() {
	pod2man epm > epm.1 || die "pod2man failed"
}

src_install() {
	dobin epm || die
	doman epm.1
}
