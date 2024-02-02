# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configuration profiles manager and scheduler for restic backup"
HOMEPAGE="https://github.com/creativeprojects/resticprofile"

ARCH="linux_amd64"
MY_PN=${PN/-bin/}
SRC_URI="https://github.com/creativeprojects/resticprofile/releases/download/v${PV}/${MY_PN}_${PV}_${ARCH}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT=(
	"/usr/sbin/resticprofile"
)

QA_PRESTRIPPED=${QA_PREBUILT}

src_install() {
	dosbin resticprofile
	dodoc README.md
}

