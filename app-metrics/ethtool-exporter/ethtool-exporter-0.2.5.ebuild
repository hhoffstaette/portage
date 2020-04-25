# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit python-any-r1

DESCRIPTION="Prometheus exporter for ethtool statistics"
HOMEPAGE="https://github.com/Showmax/prometheus-ethtool-exporter"
SRC_URI="https://github.com/Showmax/prometheus-ethtool-exporter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/prometheus_client
	sys-apps/ethtool
"

PATCHES=(
	"${FILESDIR}/${PV}-do-not-hardcode-ethtool-path.patch"
)

S="${WORKDIR}"/prometheus-${P}

pkg_setup() {
    python-any-r1_pkg_setup
}

src_install() {
	default
	mv ethtool-exporter.py ethtool-exporter
	python_fix_shebang ethtool-exporter
	python_doscript ethtool-exporter
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

