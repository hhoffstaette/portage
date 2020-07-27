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
	opt/Element/element-desktop"

S="${WORKDIR}"
DESTINATION="/"

src_unpack() {
	default
	tar xf data.tar.xz
	rm -rf opt/Element/{chrome-sandbox,crashpad_handler,swiftshader}
	rm -rf opt/Element/lib{EGL,GLESv2,vk_swiftshader,vulkan}.so
	rm -rf opt/Element/vk_swiftshader_icd.json
}

src_install() {
	# move original binary and install shell wrapper
	# See: https://github.com/electron/electron/issues/16097
	mv opt/Element/${PN} opt/Element/${PN}.bin
	cp -a "${FILESDIR}"/${PN} opt/Element
	mv usr/share/doc/${PN} usr/share/doc/${PF}
	gunzip usr/share/doc/${PF}/changelog.gz

	insinto ${DESTINATION}
	doins -r usr
	doins -r opt

	fperms +x /opt/Element/{${PN},${PN}.bin}
	fperms +x /opt/Element/libffmpeg.so

	dosym ${DESTINATION}opt/Element/${PN} ${DESTINATION}usr/bin/${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
