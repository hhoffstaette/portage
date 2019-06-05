# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

HOMEPAGE="https://github.com/jupp0r/prometheus-cpp"
DESCRIPTION="Prometheus Client Library for Modern C++"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/jupp0r/prometheus-cpp.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jupp0r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="www-servers/civetweb[cxx]"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_TESTING=OFF
		-DUSE_THIRDPARTY_LIBRARIES=OFF
	)
	cmake-utils_src_configure
}
