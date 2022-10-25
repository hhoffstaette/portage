# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit python-r1 python-utils-r1

DESCRIPTION="Visualize the layout of data on your btrfs filesystem over time"
HOMEPAGE="https://github.com/knorrie/btrfs-heatmap"
SRC_URI="https://github.com/knorrie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="dev-lang/python-exec:2
         >=sys-fs/python-btrfs-10[${PYTHON_USEDEP}]"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 arm arm64 x86"
IUSE="doc"

src_install() {
    python_foreach_impl python_newscript btrfs-heatmap btrfs-heatmap
    docompress -x /usr/share/doc/${PF}
    dodoc COPYING README.md
    use doc && dodoc -r doc/*
}

