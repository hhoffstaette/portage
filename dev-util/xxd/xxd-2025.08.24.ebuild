# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Standalone version of Vim's xxd"
HOMEPAGE="https://www.vim.org https://github.com/vim/vim"
VIM_VERSION="9.1.1652"
SRC_URI="https://github.com/vim/vim/archive/v${VIM_VERSION}.tar.gz -> vim-${VIM_VERSION}.tar.gz"
S="${WORKDIR}/vim-${VIM_VERSION}/src/xxd"
LICENSE="vim"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

src_compile() {
	emake
}

src_install() {
	dobin xxd
	doman ../../runtime/doc/xxd.1
}
