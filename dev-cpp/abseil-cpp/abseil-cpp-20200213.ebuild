# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

HOMEPAGE="https://github.com/abseil/abseil-cpp"
DESCRIPTION="Abseil Common Libraries for C++"
GIT_COMMIT="c44657f55692eddf5504156645d1f4ec7b3acabd"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
)

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DABSL_RUN_TESTS=OFF
		-DABSL_USE_GOOGLETEST_HEAD=OFF
		-DCMAKE_CXX_STANDARD=17
	)
	cmake-utils_src_configure
}
