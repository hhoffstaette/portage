# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://element.im"

inherit eutils gnome2-utils

SRC_URI="https://packages.riot.im/debian/pool/main/e/element-desktop/element-desktop_${PV}_amd64.deb"
KEYWORDS="amd64"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE=""

# maybe later:
#IUSE="emoji"
#DEPEND="emoji? ( >=media-fonts/noto-emoji-20180823 )"
DEPEND=""

RDEPEND="${DEPEND}
	dev-libs/nss
	media-libs/mesa
	net-print/cups
	x11-libs/gtk+:3"

QA_PREBUILT="
	opt/Element/libffmpeg.so
	opt/Element/element-desktop
	opt/Element/libvk_swiftshader.so"

S="${WORKDIR}"
DESTINATION="/"

src_install() {
	tar xf data.tar.xz
	mv usr/share/doc/${PN} usr/share/doc/${PF}
	gunzip usr/share/doc/${PF}/changelog.gz
	rm -rf opt/Element/{chrome-sandbox,crashpad_handler,swiftshader}
	rm -rf opt/Element/lib{EGL,GLESv2}.so
	
	insinto ${DESTINATION}
	doins -r usr
	doins -r opt
	fperms +x /opt/Element/${PN}
	fperms +x /opt/Element/{libffmpeg,libvk_swiftshader,libvulkan}.so

	dosym ${DESTINATION}opt/Element/${PN} ${DESTINATION}/usr/bin/${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
