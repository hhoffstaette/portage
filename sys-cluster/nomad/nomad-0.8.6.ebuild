# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot user

KEYWORDS="amd64"
EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="The cluster manager from Hashicorp"
HOMEPAGE="http://www.nomadproject.io"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
IUSE="+client +server lxc"

RESTRICT="test"

DEPEND="
	lxc? ( app-emulation/lxc )
	dev-go/gox
	>=dev-lang/go-1.7.5:=
	>=dev-go/go-tools-0_pre20160121"
RDEPEND=""

pkg_pretend()
{
	if ( ! use client && ! use server ) ; then
		die "At least one of USE=client or USE=server is required."
	fi
}

pkg_setup() {
	enewgroup ${PN}
	enewuser  ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	eapply_user

	sed -e 's@^\(GIT_DESCRIBE :=\).*@\1'${PV}'@' \
		-e 's@^\(GIT_COMMIT :=\).*@\1@' \
		-e 's@^\(GIT_DIRTY :=\).*@\1@' \
		-e 's@go get -u -v $(GOTOOLS)@@' \
		-e 's@ vendorfmt @@' \
		-i "${S}/src/${EGO_PN}/GNUmakefile" || die
}

src_compile() {
	GOPATH="${S}" emake -C "${S}/src/${EGO_PN}" pkg/linux_amd64$(use lxc && echo '-lxc')/${PN} GO_TAGS=ui
}

src_install() {
	local dir

	dobin "${S}/src/${EGO_PN}/pkg/linux_amd64$(use lxc && echo '-lxc')/${PN}"

	for dir in /var/{lib,log}/${PN}; do
		keepdir "${dir}"
		fowners ${PN}:${PN} "${dir}"
	done

	keepdir /etc/nomad.d
	insinto /etc/nomad.d
	doins "${FILESDIR}/"data-dir.json
	use client && doins "${FILESDIR}/"client.json
	use server && doins "${FILESDIR}/"server.json

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
