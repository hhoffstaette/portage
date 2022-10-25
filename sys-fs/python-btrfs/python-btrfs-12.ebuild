# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python module to inspect btrfs filesystems"
HOMEPAGE="https://github.com/knorrie/python-btrfs"
SRC_URI="https://github.com/knorrie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="amd64 arm arm64 x86"
IUSE="examples"

python_install_all() {
    distutils-r1_python_install_all
    if use examples; then
        docompress -x /usr/share/doc/${PF}
        rm -f examples/btrfs
        cp -a examples ${D}/usr/share/doc/${PF}
    fi
}

