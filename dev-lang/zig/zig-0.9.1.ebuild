# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ARCH="linux-x86_64"
DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
KEYWORDS="amd64"
RESTRICT="mirror"
SRC_URI="https://ziglang.org/download/${PV}/zig-${ARCH}-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="MIT"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"

QA_PREBUILT="zig"

S="${WORKDIR}/zig-${ARCH}-${PV}"
DEST="/opt/${P}"

src_install() {
	exeinto ${DEST}
	doexe zig

	insinto ${DEST}
	doins LICENSE
	doins -r doc lib

	# link to docs
	dosym "../../../opt/${P}/doc" "/usr/share/doc/${P}"

	# generate environment
	echo 'PATH="'${DEST}'"' >> zig.env
	echo 'ROOTPATH="'${DEST}'"' >> zig.env
	newenvd zig.env 70zig
}

pkg_postinst() {
	ewarn "Please run env-update and then source /etc/profile in any open shells"
	ewarn "to start using zig. Relogin to update it for any new shells."
}

