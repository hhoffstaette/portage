# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only C++ library for JSON Schema validation"
HOMEPAGE="https://github.com/tristanpenman/valijson"
SRC_URI="https://github.com/tristanpenman/valijson/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="test"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
LICENSE="BSD-2"
RESTRICT="!test? ( test )"
SLOT="0"

src_configure() {
	local mycmakeargs=(
		-Dvalijson_BUILD_TESTS=$(usex test)
	)

	if use test; then
		sed -i -e "s:../tests/data/documents/:../${P}/tests/data/documents/:" tests/test_adapter_comparison.cpp || die
		sed -i -e "s:../tests/data:../${P}/tests/data:" tests/test_validation_errors.cpp || die
		sed -i -e "s:../thirdparty/:../${P}/thirdparty/:" tests/test_validator.cpp || die
		sed -i -e "s:../doc/schema/:../${P}/doc/schema/:" tests/test_validator.cpp || die
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	# there is no target for installing headers, so do it manually
	doheader -r include/*
}

src_test() {
	cd "${BUILD_DIR}" || die
	./test_suite || die
}
