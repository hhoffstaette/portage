# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A powerful interface for container troubleshooting and security investigation"
HOMEPAGE="https://sysdig.com/opensource/inspect/"

inherit xdg-utils

MY_PN=${PN%%-bin}
SRC_URI="https://github.com/draios/sysdig-inspect/releases/download/${PV}/${MY_PN}-linux-x86_64.deb -> ${MY_PN}-${PV}-linux-x86_64.deb"

LICENSE="GPL-2"
KEYWORDS="amd64"
SLOT="0"

RDEPEND="${DEPEND}
	dev-libs/nss
	dev-debug/sysdig
	media-libs/mesa
	net-print/cups
	x11-libs/gtk+:3
"

QA_PREBUILT="
	/usr/lib/sysdig-inspect/Sysdig Inspect
	/usr/lib/sysdig-inspect/libffmpeg.so
	/usr/lib/sysdig-inspect/libnode.so
"

SYSDIG_DIR="usr/lib/sysdig-inspect/resources/app/ember-electron/resources/sysdig"
DESTINATION="/"
S="${WORKDIR}"

src_install() {
	tar xf data.tar.xz
	mv usr/share/doc/${MY_PN} usr/share/doc/${PF}

	# use native sysdig installation
	rm -f ${SYSDIG_DIR}/{csysdig,sysdig}
	rm -rf ${SYSDIG_DIR}/chisels
	ln -s /usr/bin/{csysdig,sysdig} ${SYSDIG_DIR}
	ln -s /usr/share/sysdig/chisels ${SYSDIG_DIR}

	# fix up desktop entry
	sed -i -e "s:Name=sysdig-inspect":"Name=Sysdig Inspect": usr/share/applications/sysdig-inspect.desktop
	sed -i -e "s:Categories=GNOME;GTK;Utility;":"Categories=System": usr/share/applications/sysdig-inspect.desktop

	insinto ${DESTINATION}
	doins -r usr

	fperms +x "/usr/lib/sysdig-inspect/Sysdig Inspect" \
		/usr/lib/sysdig-inspect/libffmpeg.so \
		/usr/lib/sysdig-inspect/libnode.so
}

pkg_postinst() {
	xdg_icon_cache_update
	elog "For live inspection you will also need to emerge sysdig[modules] for the kernel module."
}

pkg_postrm() {
	xdg_icon_cache_update
}
