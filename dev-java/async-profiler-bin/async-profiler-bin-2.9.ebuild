# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sampling CPU and heap profiler for Java featuring AsyncGetCallTrace + perf_events"
HOMEPAGE="https://github.com/async-profiler/async-profiler"

ARCH="linux-x64"
MY_PN=${PN/-bin/}
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}-${ARCH}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT=(
	"build/fdtransfer"
	"build/jattach"
	"build/libasyncProfiler.so"
)

QA_PRESTRIPPED=${QA_PREBUILT}

S=${WORKDIR}/${MY_PN}-${PV}-${ARCH}

src_install() {
	insinto /opt/${MY_PN}
	doins -r *.md build profiler.sh
	fperms 0755 /opt/${MY_PN}/build/{fdtransfer,jattach,libasyncProfiler.so} /opt/${MY_PN}/profiler.sh
}

