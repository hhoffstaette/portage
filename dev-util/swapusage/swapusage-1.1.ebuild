# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shows per-process swap usage."
HOMEPAGE="https://github.com/hhoffstaette/swapusage"
SRC_URI="https://github.com/hhoffstaette/swapusage/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"

src_compile() {
	emake || die "build failed."
}

src_install() {
    dobin ${PN}
}
