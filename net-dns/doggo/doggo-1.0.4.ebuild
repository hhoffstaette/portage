# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Command-line DNS Client for Humans"
HOMEPAGE="https://github.com/mr-karan/doggo"

SRC_URI="https://github.com/mr-karan/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-lang/go"

src_compile() {
	emake build-cli VERSION=${PV} || die
}

src_install() {
	newbin bin/${PN}.bin ${PN}

	for comp in bash fish zsh; do
		bin/${PN}.bin completions $comp > ${WORKDIR}/${PN}.$comp
	done

	newbashcomp ${WORKDIR}/${PN}.bash ${PN}
	newfishcomp ${WORKDIR}/${PN}.fish ${PN}.fish
	newzshcomp ${WORKDIR}/${PN}.zsh _${PN}
}
