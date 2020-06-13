# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module user systemd

DESCRIPTION="Nomad statistics exporter for Prometheus"
HOMEPAGE="https://gitlab.com/yakshaving.art/nomad-exporter"
RESTRICT="mirror"

COMMIT_ID="ae588b56"
COMMIT_DATE="2019-10-10T15:53"

EGO_SUM=(
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/docker/go-units v0.3.3"
	"github.com/docker/go-units v0.3.3/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.1"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/gorhill/cronexpr v0.0.0-20180427100037-88b0669f7d75"
	"github.com/gorhill/cronexpr v0.0.0-20180427100037-88b0669f7d75/go.mod"
	"github.com/gorilla/websocket v1.4.0"
	"github.com/gorilla/websocket v1.4.0/go.mod"
	"github.com/hashicorp/go-cleanhttp v0.5.1"
	"github.com/hashicorp/go-cleanhttp v0.5.1/go.mod"
	"github.com/hashicorp/go-rootcerts v1.0.0"
	"github.com/hashicorp/go-rootcerts v1.0.0/go.mod"
	"github.com/hashicorp/go-uuid v1.0.1"
	"github.com/hashicorp/go-uuid v1.0.1/go.mod"
	"github.com/hashicorp/go-version v1.1.0"
	"github.com/hashicorp/go-version v1.1.0/go.mod"
	"github.com/hashicorp/nomad/api v0.0.0-20190614224134-78da9b6ee8df"
	"github.com/hashicorp/nomad/api v0.0.0-20190614224134-78da9b6ee8df/go.mod"
	"github.com/hpcloud/tail v1.0.0"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.0"
	"github.com/matttproud/golang_protobuf_extensions v1.0.0/go.mod"
	"github.com/mitchellh/go-homedir v1.0.0"
	"github.com/mitchellh/go-homedir v1.0.0/go.mod"
	"github.com/mitchellh/go-testing-interface v1.0.0"
	"github.com/mitchellh/go-testing-interface v1.0.0/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/ginkgo v1.8.0"
	"github.com/onsi/ginkgo v1.8.0/go.mod"
	"github.com/onsi/gomega v1.5.0"
	"github.com/onsi/gomega v1.5.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v0.8.0"
	"github.com/prometheus/client_golang v0.8.0/go.mod"
	"github.com/prometheus/client_model v0.0.0-20171117100541-99fa1f4be8e5"
	"github.com/prometheus/client_model v0.0.0-20171117100541-99fa1f4be8e5/go.mod"
	"github.com/prometheus/common v0.0.0-20180426121432-d811d2e9bf89"
	"github.com/prometheus/common v0.0.0-20180426121432-d811d2e9bf89/go.mod"
	"github.com/prometheus/procfs v0.0.0-20180408092902-8b1c2da0d56d"
	"github.com/prometheus/procfs v0.0.0-20180408092902-8b1c2da0d56d/go.mod"
	"github.com/sirupsen/logrus v1.0.5"
	"github.com/sirupsen/logrus v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190403152447-81d4e9dc473e"
	"golang.org/x/sys v0.0.0-20190403152447-81d4e9dc473e/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.1-0.20181227161524-e6919f6577db"
	"golang.org/x/text v0.3.1-0.20181227161524-e6919f6577db/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/airbrake/gobrake.v2 v2.0.9"
	"gopkg.in/airbrake/gobrake.v2 v2.0.9/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/gemnasium/logrus-airbrake-hook.v2 v2.1.2"
	"gopkg.in/gemnasium/logrus-airbrake-hook.v2 v2.1.2/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.1"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	)
go-module_set_globals

EGO_PN="gitlab.com/yakshaving.art/nomad-exporter"

SRC_URI="https://${EGO_PN}/-/archive/${PV}/${P}.tar.gz
	${EGO_SUM_SRC_URI}"

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

