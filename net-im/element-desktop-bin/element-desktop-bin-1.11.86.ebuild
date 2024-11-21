# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature unpacker xdg

MY_PN="${PN/-bin}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="A glossy Matrix collaboration client for desktop (binary package)"
HOMEPAGE="https://element.io"
SRC_URI="https://packages.element.io/debian/pool/main/e/element-desktop/${MY_PN}_${MY_PV}_amd64.deb"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="splitdebug"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	virtual/udev
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango"

QA_PREBUILT="
	/opt/Element/chrome_crashpad_handler
	/opt/Element/chrome-sandbox
	/opt/Element/element-desktop
	/opt/Element/libEGL.so
	/opt/Element/libGLESv2.so
	/opt/Element/libffmpeg.so
	/opt/Element/libvk_swiftshader.so
	/opt/Element/libvulkan.so.1
	/opt/Element/resources/app.asar.unpacked/node_modules/matrix-seshat/index.node
	/opt/Element/resources/app.asar.unpacked/node_modules/keytar/build/Release/keytar.node"

src_prepare() {
	default
	rm opt/Element/{LICENSE.electron.txt,LICENSES.chromium.html} || die
}

src_install() {
	# move original binary and install shell wrapper
	# See: https://github.com/electron/electron/issues/16097
	mv opt/Element/${MY_PN} opt/Element/${MY_PN}.bin
	cp -a "${FILESDIR}"/${MY_PN} opt/Element

	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die
	gunzip usr/share/doc/${PF}/changelog.gz || die

	insinto /
	doins -r usr
	doins -r opt

	local f
	for f in ${QA_PREBUILT}; do
		fperms +x "${f}"
	done

	fperms +x "${f}" /opt/Element/${MY_PN}.bin
	dosym ../../opt/Element/${MY_PN} /usr/bin/${MY_PN}
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "emojis" media-fonts/noto-emoji
}
