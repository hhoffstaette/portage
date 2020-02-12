# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A powerful interface for container troubleshooting and security investigation"
HOMEPAGE="https://sysdig.com/opensource/inspect/"

inherit eutils gnome2-utils

SRC_URI="https://download.sysdig.com/stable/sysdig-inspect/${PN}_${PV}_amd64.deb"

KEYWORDS="amd64"

LICENSE="GPL-2"
SLOT="0"
REQUIRED_USE=""
DEPEND=""

# not sure if this list is complete;
# let me know if something is missing
RDEPEND="${DEPEND}
	dev-libs/nss
	media-libs/mesa
	net-print/cups
	x11-libs/gtk+:3"

QA_PREBUILT="
	/usr/lib/sysdig-inspect/Sysdig Inspect
	/usr/lib/sysdig-inspect/libffmpeg.so
	/usr/lib/sysdig-inspect/libnode.so
	/usr/lib/sysdig-inspect/resources/app/ember-electron/resources/sysdig/csysdig
	/usr/lib/sysdig-inspect/resources/app/ember-electron/resources/sysdig/sysdig"

DESTINATION="/"
S="${WORKDIR}"

src_install() {
	tar xf data.tar.xz
	mv usr/share/doc/${PN} usr/share/doc/${PF}

	insinto ${DESTINATION}
	doins -r usr

	fperms +x "/usr/lib/sysdig-inspect/Sysdig Inspect" \
		/usr/lib/sysdig-inspect/libffmpeg.so \
		/usr/lib/sysdig-inspect/libnode.so \
		/usr/lib/sysdig-inspect/resources/app/ember-electron/resources/sysdig/csysdig \
		/usr/lib/sysdig-inspect/resources/app/ember-electron/resources/sysdig/sysdig
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "For live inspection you will also need to emerge sysdig[modules] for the kernel module."
}

pkg_postrm() {
	gnome2_icon_cache_update
}

