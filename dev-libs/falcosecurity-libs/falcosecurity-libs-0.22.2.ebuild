# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cmake flag-o-matic linux-info

DESCRIPTION="libsinsp, libscap, and the scap kernel driver for sysdig"
HOMEPAGE="https://falcosecurity.github.io/libs/"
SRC_URI="https://github.com/falcosecurity/libs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
#KEYWORDS="~amd64"
IUSE="bpf"

RDEPEND="dev-cpp/abseil-cpp:=
	dev-cpp/tbb:=
	dev-cpp/yaml-cpp:=
	dev-libs/jsoncpp:=
	dev-libs/libb64:=
	bpf? ( >=dev-libs/libbpf-1.1:= )
	dev-libs/protobuf:=
	dev-libs/re2:=
	dev-libs/uthash
	net-misc/curl
	sys-libs/ncurses:=
	virtual/libelf:=
	virtual/zlib:=
"

DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	dev-cpp/valijson
	virtual/os-headers
"

DEPEND="bpf? (
			dev-util/bpftool
			llvm-core/clang:*[llvm_targets_BPF]
		)
"

S="${WORKDIR}/libs-${PV}"

pkg_pretend() {
	if use bpf; then
		local CONFIG_CHECK="
			~BPF
			~BPF_EVENTS
			~BPF_JIT
			~BPF_SYSCALL
			~FTRACE_SYSCALLS
			~HAVE_EBPF_JIT
		"
		check_extra_config
	fi
}

src_prepare() {
	# do not build with debugging info
	sed -i -e 's/-ggdb//g' CMakeLists.txt "${WORKDIR}"/libs-${PV}/cmake/modules/CompilerFlags.cmake || die

	cmake_src_prepare
}

src_configure() {
	# known problems with strict aliasing:
	# https://github.com/falcosecurity/libs/issues/1964
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		# do not build any driver(s)
		-DBUILD_DRIVER=OFF
		-DENABLE_DKMS=OFF

		# build modern BPF probe depending on USE
		-DBUILD_LIBSCAP_MODERN_BPF=$(usex bpf)

		# disable all test targets
		-DCREATE_TEST_TARGETS=OFF

		# libscap examples are not installed or really useful
		-DBUILD_LIBSCAP_EXAMPLES=OFF

		# build libs as shared
		-DBUILD_SHARED_LIBS=ON

		# do not use bundled dependencies
		-DUSE_BUNDLED_DEPS=OFF

		# set valijson include path to prevent downloading
		-DVALIJSON_INCLUDE="${ESYSROOT}"/usr/include
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove driver headers
	rm -r "${ED}"/usr/src || die
}
