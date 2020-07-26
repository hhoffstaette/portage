# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Supercharge your API workflow"
HOMEPAGE="https://www.getpostman.com/"
SRC_URI="https://dl.pstmn.io/download/version/${PV}/linux64 -> ${P}.tar.gz"

KEYWORDS="amd64"
LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}
	dev-libs/nss
	media-libs/mesa
	net-print/cups
	x11-libs/gtk+:3"

QA_PREBUILT="
	opt/postman/libffmpeg.so
	opt/postman/Postman
	opt/postman/_Postman"

S="${WORKDIR}/Postman/app"

src_unpack() {
	default
	rm -rf Postman/app/{chrome-sandbox,swiftshader}
	rm -rf Postman/app/lib{EGL,GLESv2}.so
}

src_install() {
	insinto /opt/${PN}
	doins -r *

	exeinto /opt/${PN}
	doexe Postman _Postman

	dosym ../../opt/${PN}/Postman /usr/bin/${PN}

	newicon -s 128 "${S}/resources/app/assets/icon.png" postman.png

	make_desktop_entry "postman" \
		"Postman" \
		"/usr/share/icons/hicolor/128x128/apps/postman.png" \
		"Development"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
