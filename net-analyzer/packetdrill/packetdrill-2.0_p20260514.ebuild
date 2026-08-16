# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic  toolchain-funcs

DESCRIPTION="Tool for quick, precise testing of entire TCP/UDP/IPv4/IPv6 network stacks"
HOMEPAGE="https://github.com/google/packetdrill"

# no up-to-date releases or tags
COMMIT="2c4001c4d6fc04a3bbd01d4b92be62717a37648a"
SRC_URI="https://github.com/google/packetdrill/archive/${COMMIT}.tar.gz -> packetdrill-${PV}.tar.gz"
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

DOCS=( README.md syntax.md )

src_compile() {
	# remove homegrown duplicate
	rm assert.h || die

	# build with proper flags
	append-flags -Wno-unused-result
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake tests
}

src_install() {
	dobin packetdrill

	cd "${WORKDIR}/${PN}-${COMMIT}" && einstalldocs
}
