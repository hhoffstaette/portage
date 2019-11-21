# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module user systemd

DESCRIPTION="Nomad statistics exporter for Prometheus"
HOMEPAGE="https://gitlab.com/yakshaving.art/nomad-exporter"
RESTRICT="mirror"

COMMIT_ID="ae588b56"
COMMIT_DATE="2019-10-10T15:53"

EGO_VENDOR=(
	"github.com/beorn7/perks 3a771d992973"
	"github.com/golang/protobuf v1.3.1"
	"github.com/gorhill/cronexpr 88b0669f7d75"
	"github.com/gorilla/websocket v1.4.0"
	"github.com/hashicorp/go-cleanhttp v0.5.1"
	"github.com/hashicorp/go-rootcerts v1.0.0"
	"github.com/hashicorp/go-version v1.1.0"
	"github.com/hashicorp/nomad 78da9b6ee8df github.com/hashicorp/nomad"
	"github.com/matttproud/golang_protobuf_extensions v1.0.0"
	"github.com/mitchellh/go-homedir v1.0.0"
	"github.com/prometheus/client_golang v0.8.0"
	"github.com/prometheus/client_model 99fa1f4be8e5"
	"github.com/prometheus/common d811d2e9bf89"
	"github.com/prometheus/procfs 8b1c2da0d56d"
	"github.com/sirupsen/logrus v1.0.5"
	"golang.org/x/crypto c2843e01d9a2 github.com/golang/crypto"
	"golang.org/x/sys 81d4e9dc473e github.com/golang/sys"
)

EGO_PN="gitlab.com/yakshaving.art/nomad-exporter"

SRC_URI="https://${EGO_PN}/-/archive/${PV}/${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0"
KEYWORDS="amd64"
SLOT="0"
IUSE=""

DOCS=( README.md )

pkg_setup() {
	enewgroup nomad-exporter
	enewuser nomad-exporter -1 -1 -1 nomad-exporter
}

src_compile() {
	make build COMMIT_ID=${COMMIT_ID} COMMIT_DATE=${COMMIT_DATE} VERSION=${PV} || die
}

src_install() {
	strip nomad-exporter
	dobin nomad-exporter
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	diropts -o nomad-exporter -g nomad-exporter -m 0750
	keepdir /var/log/nomad-exporter
}

