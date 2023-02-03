# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/envoyproxy/data-plane-api/archive/9c42588c956220b48eb3099d186487c2f04d32ec.tar.gz -> ${P}-envoy-api.tar.gz
	https://github.com/googleapis/googleapis/archive/2f9af297c84c55c8b871ba4495e01ade42476c92.tar.gz -> ${P}-googleapis.tar.gz
	https://github.com/census-instrumentation/opencensus-proto/archive/v0.3.0.tar.gz -> ${P}-opencensus-proto.tar.gz"

LICENSE="Apache-2.0"
# format is 0/${CORE_SOVERSION//./}.${CPP_SOVERSION//./} , check top level CMakeLists.txt
SLOT="0/30.152"
KEYWORDS="amd64 arm64 ppc64 riscv x86"
IUSE="doc examples test"

# look for submodule versions in third_party dir
RDEPEND="
	>=dev-cpp/abseil-cpp-20220623:=
	>=dev-libs/re2-0.2021.11.01:=
	>=dev-libs/openssl-1.1.1:0=[-bindist(-)]
	>=dev-libs/protobuf-3.18.1:=
	dev-libs/xxhash
	>=net-dns/c-ares-1.15.0:=
	sys-libs/zlib:=
"

DEPEND="${RDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/gflags
	)
"

BDEPEND="virtual/pkgconfig"

# requires sources of many google tools
RESTRICT="test"

S="${WORKDIR}/${PN}-${PV}"

soversion_check() {
	local core_sover cpp_sover
	# extract quoted number. line we check looks like this: 'set(gRPC_CPP_SOVERSION    "1.37")'
	core_sover="$(grep 'set(gRPC_CORE_SOVERSION ' CMakeLists.txt  | sed '/.*\"\(.*\)\".*/ s//\1/')"
	cpp_sover="$(grep 'set(gRPC_CPP_SOVERSION ' CMakeLists.txt  | sed '/.*\"\(.*\)\".*/ s//\1/')"
	# remove dots, e.g. 1.37 -> 137
	core_sover="${core_sover//./}"
	cpp_sover="${cpp_sover//./}"
	[[ ${core_sover} -eq $(ver_cut 2 ${SLOT}) ]] || die "fix core sublot! should be ${core_sover}"
	[[ ${cpp_sover} -eq $(ver_cut 3 ${SLOT}) ]] || die "fix cpp sublot! should be ${cpp_sover}"
}

src_unpack() {
	# skip default

	# main package
	tar xf $DISTDIR/${P}.tar.gz

	# prepare additional target directories
	mkdir -p ${P}/third_party/envoy-api
	tar xf $DISTDIR/${P}-envoy-api.tar.gz -C ${P}/third_party/envoy-api
	
	mkdir -p ${P}/third_party/googleapis
	tar xf $DISTDIR/${P}-googleapis.tar.gz -C ${P}/third_party/googleapis

	mkdir -p ${P}/third_party/opencensus-proto/src
	tar xf $DISTDIR/${P}-opencensus-proto.tar.gz -C ${P}/third_party/opencensus-proto/src
}

src_prepare() {
	cmake_src_prepare

	# un-hardcode libdir
	sed -i "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" CMakeLists.txt || die
	sed -i "s@/lib@/$(get_libdir)@" cmake/pkg-config-template.pc.in || die

	soversion_check
}

src_configure() {
	local mycmakeargs=(
		-DgRPC_INSTALL=ON
		-DgRPC_ABSL_PROVIDER=package
		-DgRPC_BACKWARDS_COMPATIBILITY_MODE=OFF
		-DgRPC_CARES_PROVIDER=package
		-DgRPC_INSTALL_CMAKEDIR="$(get_libdir)/cmake/${PN}"
		-DgRPC_INSTALL_LIBDIR="$(get_libdir)"
		-DgRPC_PROTOBUF_PROVIDER=package
		-DgRPC_RE2_PROVIDER=package
		-DgRPC_SSL_PROVIDER=package
		-DgRPC_ZLIB_PROVIDER=package
		-DgRPC_BUILD_TESTS=$(usex test)
		-DCMAKE_CXX_STANDARD=17
		$(usex test '-DgRPC_BENCHMARK_PROVIDER=package' '')
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		find examples -name '.gitignore' -delete || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		find doc -name '.gitignore' -delete || die
		local DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )
	fi

	einstalldocs
}
