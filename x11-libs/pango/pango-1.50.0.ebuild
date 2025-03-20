# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal toolchain-funcs

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://www.pango.org/"

# CLOSE YOUR EYES: PANGO IS REALLY 1.42.4++
REAL_V="1.42.4"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/pango/$(ver_cut 1-2 ${REAL_V})/${PN}-${REAL_V}.tar.xz"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${PN}-${REAL_V}-patchset.tar.xz"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="X +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=media-libs/harfbuzz-1.4.2:=[glib(+),truetype(+),${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.2:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.12.92:1.0=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4:=[X?,${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-0.19.7[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.20
	virtual/pkgconfig
	test? ( media-fonts/cantarell )
	X? ( x11-base/xorg-proto )
	!<=dev-build/autoconf-2.63:2.5
"

PATCHES=(
	# cherry-pick bug fixes from master by 20190216;
	# each patch has commit id of origin/master included and will be part of 1.44
	"${WORKDIR}"/patches/
	"${FILESDIR}"/${REAL_V}-CVE-2019-1010238.patch
	# Compatibility hacks
	"${FILESDIR}"/${REAL_V}-pango_font_metrics_get_height.patch
)

S="${WORKDIR}/${PN}-${REAL_V}"

src_prepare() {
	gnome2_src_prepare
	# This should be updated if next release fails to pre-generate the manpage as well,
	# or src_prepare removed if is properly generated.
	# https://gitlab.gnome.org/GNOME/pango/issues/270
	cp -v "${FILESDIR}"/${REAL_V}-pango-view.1.in "${S}/utils/pango-view.1.in" || die
}

multilib_src_configure() {
	tc-export CXX

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--with-cairo \
		$(multilib_native_use_enable introspection) \
		$(use_with X xft) \
		"$(usex X --x-includes="${EPREFIX}/usr/include" "")" \
		"$(usex X --x-libraries="${EPREFIX}/usr/$(get_libdir)" "")"

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/html docs/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
	# fake it for pkgconfig
	sed -i "s/^Version: ${REAL_V}/Version: ${PV}/g" "${ED}"/usr/$(get_libdir)/pkgconfig/*.pc || die
}
