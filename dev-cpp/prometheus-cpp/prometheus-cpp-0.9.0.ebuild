# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

HOMEPAGE="https://github.com/jupp0r/prometheus-cpp"
DESCRIPTION="Prometheus Client Library for Modern C++"
SRC_URI="https://github.com/jupp0r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="www-servers/civetweb[cxx]"
DEPEND="${RDEPEND}"

PATCHES=(
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_TESTING=OFF
		-DUSE_THIRDPARTY_LIBRARIES=OFF
	)
	cmake_src_configure
}
