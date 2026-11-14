# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://github.com/BratishkaErik/ncdu"
SRC_URI="
	amd64? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-x86_64.tar.gz )
	arm? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-arm.tar.gz )
	arm64? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-aarch64.tar.gz )
	x86? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-x86.tar.gz )
	https://raw.githubusercontent.com/BratishkaErik/ncdu/refs/heads/zig-version/ncdu.1
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"
IUSE="symlink"

RDEPEND="symlink? ( !sys-fs/ncdu )"

QA_PREBUILT="usr/bin/ncdu-bin"

src_install() {
	newbin ncdu ncdu-bin
	doman "${DISTDIR}"/ncdu.1

    if use symlink ; then
        dosym ncdu-bin /usr/bin/ncdu
    fi
}
