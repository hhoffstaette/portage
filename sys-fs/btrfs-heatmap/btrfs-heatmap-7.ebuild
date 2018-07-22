# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit python-r1 python-utils-r1

DESCRIPTION="Visualize the layout of data on your btrfs filesystem over time"
HOMEPAGE="https://github.com/knorrie/btrfs-heatmap"
SRC_URI="https://github.com/knorrie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="dev-lang/python-exec:2
         sys-fs/python-btrfs[${PYTHON_USEDEP}]"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="doc"

src_install() {
    python_foreach_impl python_newscript heatmap.py btrfs-heatmap
    docompress -x /usr/share/doc/${PF}
    dodoc COPYING README.md
    use doc && dodoc -r doc/*
}

