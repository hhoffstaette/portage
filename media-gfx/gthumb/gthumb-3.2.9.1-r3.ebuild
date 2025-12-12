# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Image viewer and browser for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/gthumb"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="cdr exif http jpeg json libsecret raw slideshow svg tiff test webp"

COMMON_DEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/glib:2
	media-libs/libpng:0=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	virtual/zlib:=

	cdr? ( >=app-cdr/brasero-3.2 )
	exif? ( >=media-gfx/exiv2-0.21:= )
	http? ( >=net-libs/libsoup-gnome-2.36:2.4 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	json? ( >=dev-libs/json-glib-0.15.0 )
	libsecret? ( >=app-crypt/libsecret-0.11 )
	slideshow? (
		>=media-libs/clutter-1:1.0
		>=media-libs/clutter-gtk-1:1.0 )
	svg? ( >=gnome-base/librsvg-2.34:2 )
	tiff? ( media-libs/tiff:= )
	raw? ( >=media-libs/libopenraw-0.0.8:= )
	webp? ( media-libs/libwebp:= )
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gsettings-desktop-schemas-0.1.4
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )
"
# eautoreconf needs:
#	gnome-base/gnome-common

PATCHES=(
	"${FILESDIR}"/${PV}-exiv2-0.27.patch
	"${FILESDIR}"/${PV}-exiv2-ignore-binary-comment.patch
	"${FILESDIR}"/${PV}-exiv2-0.28.patch
	"${FILESDIR}"/${PV}-glib-content-type.patch
	"${FILESDIR}"/${PV}-glib-sort-order.patch
	"${FILESDIR}"/${PV}-fix-incompatible-type-assignment-warnings.patch
	"${FILESDIR}"/${PV}-null-pixbuf.patch
)

src_prepare() {
	# Remove unwanted CFLAGS added with USE=debug
	sed -e 's/CFLAGS="$CFLAGS -g -O0 -DDEBUG"//' \
		-i configure.ac -i configure || die

	gnome2_src_prepare
}

src_configure() {
	# Upstream says in configure help that libchamplain support
	# crashes frequently
	gnome2_src_configure \
		--disable-gstreamer \
		--disable-libchamplain \
		--disable-static \
		--disable-webkit2 \
		$(use_enable cdr libbrasero) \
		$(use_enable exif exiv2) \
		$(use_enable http libsoup) \
		$(use_enable jpeg) \
		$(use_enable json libjson-glib) \
		$(use_enable libsecret) \
		$(use_enable raw libopenraw) \
		$(use_enable slideshow clutter) \
		$(use_enable svg librsvg) \
		$(use_enable test test-suite) \
		$(use_enable tiff) \
		$(use_enable webp libwebp)
}
