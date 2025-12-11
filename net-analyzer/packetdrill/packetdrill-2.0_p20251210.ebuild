# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool for quick, precise testing of entire TCP/UDP/IPv4/IPv6 network stacks"
HOMEPAGE="https://github.com/google/packetdrill"

# no up-to-date releases or tags
COMMIT="1866fd111a6197f83f7fcdbb58dbe63936e2dad2"
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

DOCS=( README.md syntax.md )

PATCHES=(
	"${FILESDIR}/20250604-no-static-linking.patch"
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

	cd "${WORKDIR}/${PN}-${COMMIT}" && einstalldocs
}
