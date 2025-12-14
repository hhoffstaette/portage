# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus Query CLI"
HOMEPAGE="https://github.com/nalbury/promql-cli"
KEYWORDS="amd64 arm64"
LICENSE="Apache-2.0"
SLOT="0"

RESTRICT="mirror"

DEPEND=""

SRC_URI="https://github.com/nalbury/promql-cli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.applied-asynchrony.com/distfiles/${P}-deps.tar.xz"

src_prepare() {
	default

	# fix hardcoded version: https://github.com/nalbury/promql-cli/issues/37
	sed -i 's/Version: .*/Version: \"'${PV}'\"\,/g' cmd/root.go || die
}

src_compile() {
	ego build || die
}

src_install() {
	newbin ${PN} ${PN/-cli/}
}
