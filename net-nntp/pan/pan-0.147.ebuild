# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

MY_PV=${PV/./_}
DESCRIPTION="A newsreader for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/pan"
SRC_URI="https://gitlab.gnome.org/GNOME/pan/-/archive/PAN_${MY_PV}/pan-PAN_${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="dbus gnome-keyring libnotify spell ssl"

RDEPEND="
	>=dev-libs/glib-2.26:2
	dev-libs/gmime:2.6
	>=sys-libs/zlib-1.2.0
	>=x11-libs/gtk+-2.16:2
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.2 )
	libnotify? ( >=x11-libs/libnotify-0.4.1:0= )
	spell? (
		>=app-text/enchant-1.6:0/0
		>=app-text/gtkspell-2.0.7:2 )
	ssl? ( >=net-libs/gnutls-3:0= )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-PAN_${MY_PV}"

src_configure() {
	# Wait for webkitgtk4 support
	# gtk3 support is still not ready (follow what Fedora does)
	# gmime:3.0 support claimed to be experimental still in 0.145, waiting with it until it's not experimental anymore or we work towards removing :2.6
    NOCONFIGURE=1 ./autogen.sh
	gnome2_src_configure \
		--with-yelp-tools \
		--without-gtk3 \
		--without-gmime30 \
		--without-webkit \
		$(use_with dbus) \
		$(use_enable gnome-keyring gkr) \
		$(use_with spell gtkspell) \
		$(use_enable libnotify) \
		$(use_with ssl gnutls)
}
