# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils user go-module

KEYWORDS="amd64"
EGIT_COMMIT="v${PV}"
EGO_PN=github.com/hhoffstaette/${PN}

DESCRIPTION="Fritz!Box Upnp statistics exporter for Prometheus"
HOMEPAGE="https://github.com/hhoffstaette/fritzbox_exporter"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

EGO_SUM=(
	"github.com/beorn7/perks v0.0.0-20160804104726-4c0e84591b9a"
	"github.com/beorn7/perks v0.0.0-20160804104726-4c0e84591b9a/go.mod"
	"github.com/golang/protobuf v0.0.0-20160817174113-f592bd283e9e"
	"github.com/golang/protobuf v0.0.0-20160817174113-f592bd283e9e/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/prometheus/client_golang v0.8.1-0.20161017123536-334af0119a8f"
	"github.com/prometheus/client_golang v0.8.1-0.20161017123536-334af0119a8f/go.mod"
	"github.com/prometheus/client_model v0.0.0-20150212101744-fa8ad6fec335"
	"github.com/prometheus/client_model v0.0.0-20150212101744-fa8ad6fec335/go.mod"
	"github.com/prometheus/common v0.0.0-20160801171955-ebdfc6da4652"
	"github.com/prometheus/common v0.0.0-20160801171955-ebdfc6da4652/go.mod"
	"github.com/prometheus/procfs v0.0.0-20160411190841-abf152e5f3e9"
	"github.com/prometheus/procfs v0.0.0-20160411190841-abf152e5f3e9/go.mod"
	)
go-module_set_globals

SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	cd ${S}
	go build
}

src_install() {
	strip fritzbox_exporter
	dobin fritzbox_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

