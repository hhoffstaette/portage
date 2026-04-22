# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="A PDF processor written in Go"
HOMEPAGE="https://github.com/pdfcpu/pdfcpu"

SRC_URI="https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz
"

S="${S}/cmd/pdfcpu"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build
}

src_install() {
	newbin ${PN} ${PN}

	local comp
	for comp in bash fish zsh; do
		./${PN} completion $comp > "${WORKDIR}"/${PN}.$comp || die
	done

	newbashcomp "${WORKDIR}"/${PN}.bash ${PN}
	newfishcomp "${WORKDIR}"/${PN}.fish ${PN}.fish
	newzshcomp "${WORKDIR}"/${PN}.zsh _${PN}
}
