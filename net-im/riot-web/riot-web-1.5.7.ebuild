# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://riot.im"

inherit eutils gnome2-utils

SRC_URI="https://packages.riot.im/debian/pool/main/r/riot-web/riot-web_1.5.7_amd64.deb"
KEYWORDS="amd64"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE=""

# maybe later:
#IUSE="emoji"
#DEPEND="emoji? ( >=media-fonts/noto-emoji-20180823 )"
DEPEND=""

# not sure if this list is complete;
# let me know if something is missing
RDEPEND="${DEPEND}
	dev-libs/nss
	media-libs/mesa
	net-print/cups
	x11-libs/gtk+:3"

QA_PREBUILT="
	opt/Riot/libffmpeg.so
	opt/Riot/riot-web
	opt/Riot/swiftshader/libvk_swiftshader.so"

DESTINATION="/"
S="${WORKDIR}"

src_install() {
	tar xf data.tar.xz
	mv usr/share/doc/${PN} usr/share/doc/${PF}
	gunzip usr/share/doc/${PF}/changelog.gz
	rm -f opt/Riot/lib{EGL,GLESv2}.so opt/Riot/swiftshader/lib{EGL,GLESv2}.so

	insinto ${DESTINATION}
	doins -r usr
	doins -r opt
	fperms +x /opt/Riot/${PN} \
		/opt/Riot/chrome-sandbox \
		/opt/Riot/libffmpeg.so \
		/opt/Riot/swiftshader/libvk_swiftshader.so 

	dosym ${DESTINATION}opt/Riot/${PN} ${DESTINATION}/usr/bin/${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
