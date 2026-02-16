# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSNMALLOC_BUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
