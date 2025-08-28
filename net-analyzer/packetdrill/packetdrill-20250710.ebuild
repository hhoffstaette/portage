# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool for quick, precise testing of entire TCP/UDP/IPv4/IPv6 network stacks"
HOMEPAGE="https://github.com/google/packetdrill"

COMMIT="f88d6e64ffbee1c893e60d33c043f8ec9027f642"
SRC_URI="https://github.com/google/packetdrill/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}/gtests/net/packetdrill"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-kernel/linux-headers
"

PATCHES=(
	"${FILESDIR}/20250604-no-static-linking.patch"
	"${FILESDIR}/20250604-stdbool.patch"
)

src_compile() {
	# remove homegrown duplicate
	rm assert.h || die

	# build with proper flags
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake tests
}

src_install() {
	dobin packetdrill
}
