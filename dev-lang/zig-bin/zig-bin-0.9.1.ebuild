# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
SRC_URI="https://ziglang.org/download/${PV}/zig-linux-x86_64-${PV}.tar.xz -> ${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"

QA_PREBUILT="zig"

S="${WORKDIR}/zig-linux-x86_64-${PV}"
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
	echo 'PATH="'${DEST}'"' >> zig-bin.env
	echo 'ROOTPATH="'${DEST}'"' >> zig-bin.env
	newenvd zig-bin.env 70zig-bin
}

pkg_postinst() {
	ewarn "Please run env-update and then source /etc/profile in any open shells"
	ewarn "to start using zig. Relogin to update it for any new shells."
}

