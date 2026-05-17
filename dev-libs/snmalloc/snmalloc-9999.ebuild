# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Message passing based allocator"
HOMEPAGE="https://github.com/microsoft/snmalloc"

if [[ ${PV} == *9999* ]] ; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/microsoft/snmalloc.git"
else
	SRC_URI="https://github.com/microsoft/snmalloc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSNMALLOC_BUILD_TESTING=$(usex test)
		-DSNMALLOC_HEADER_ONLY_LIBRARY=OFF
		-DSNMALLOC_LINKER_FLAVOUR=$(tc-getLD)
		-DSNMALLOC_MEMCPY_OVERRIDE=OFF
		-DSNMALLOC_STATIC_LIBRARY=$(usex static-libs ON OFF)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# always installs libsnmalloc-new-override.a
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
}
