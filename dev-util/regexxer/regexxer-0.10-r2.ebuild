# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gnome2

DESCRIPTION="An interactive tool for performing search and replace operations"
HOMEPAGE="http://regexxer.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-glib-2.32.patch
	"${FILESDIR}"/${P}-sandbox.patch
	"${FILESDIR}"/${P}-exception-prefdialog.patch
)

src_prepare() {
	default

	# fix gettext macros to work with 1.0 (similar to bug #946128)
	# eautoreconf will call autopoint, which will install any necessary files
	# from the version we set in configure.ac
	local gettext_version=$(gettextize --version | awk '/GNU gettext-tools/{print $NF}' || die)
	sed -i "s/^AM_GNU_GETTEXT_VERSION(.*)/AM_GNU_GETTEXT_VERSION([${gettext_version}])/g" configure.ac || die

	eautoreconf
}
