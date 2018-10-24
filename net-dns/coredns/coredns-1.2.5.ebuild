# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/mholt/caddy 1f7b5abc80679fb71ee0e04ed98cbe284b1fc181"
	"github.com/miekg/dns 915ca3d5ffd945235828a097c917311a9d86ebb4"
	"github.com/prometheus/client_golang c5b7fccd204277076155f10851dad72b76a49317"
	"github.com/prometheus/procfs 185b4288413d2a0dd0806f78c90dde719829e5ae"
)

EGO_PN="github.com/${PN}/${PN}"

inherit eutils golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# keep this in sync with the version
GITCOMMIT="204537b"
KEYWORDS="amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_prepare() {
	pushd src/${EGO_PN} || die
	default
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -v -ldflags="-X github.com/coredns/coredns/coremain.GitCommit=${GITCOMMIT}" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN}
	dobin ${PN}
	dodoc README.md
	popd || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc
	doins "${FILESDIR}"/${PN}.conf
}

pkg_postinst() {
	elog
	elog A minimal configuration to act as caching forwarding server
	elog has been installed as /etc/coredns.conf - please review it
	elog before starting CoreDNS.
	elog
	elog For more information see https://coredns.io/manual/toc/
	elog
}

