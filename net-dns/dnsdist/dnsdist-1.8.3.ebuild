# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit flag-o-matic lua-single

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="https://dnsdist.org"

SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
KEYWORDS="amd64 arm64 ppc64"

LICENSE="GPL-2"
SLOT="0"
IUSE="bpf dnscrypt dnstap doh gnutls lmdb regex snmp ssl systemd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}
		dnscrypt? ( ssl )
		gnutls? ( ssl )
		doh? ( ssl !gnutls )"

RDEPEND="acct-group/dnsdist
	acct-user/dnsdist
	dev-libs/boost:=
	dev-libs/libedit:=
	dev-libs/libsodium:=
	dnstap? ( dev-libs/fstrm:= )
	doh? ( net-libs/nghttp2:= )
	lmdb? ( dev-db/lmdb:= )
	regex? ( dev-libs/re2:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
	systemd? ( sys-apps/systemd:0= )
	${LUA_DEPS}
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
PATCHES=(
)

src_prepare() {
	default

	# clean up duplicate
	rm -f README.md
}

src_configure() {
	# bug #822855
	append-lfs-flags

	# re-enable outgoing doh in 1.9
	# $(use_enable doh dns-over-https) \

	econf \
		--sysconfdir=/etc/dnsdist \
		--with-lua="${ELUA}" \
		$(use_with bpf ebpf ) \
		$(use_enable dnscrypt) \
		$(use_enable dnstap) \
		$(use_with doh nghttp2 ) \
		$(use_with lmdb ) \
		$(use_with regex re2) \
		$(use_with snmp net-snmp) \
		$(use ssl && { echo "--enable-dns-over-tls" && use_with gnutls && use_with !gnutls libssl;} || echo "--without-gnutls --without-libssl") \
		$(use_enable systemd) \
		$(use_enable test unit-tests)
		sed 's/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl$libdir'\''/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl\/$libdir'\''/g' \
			-i "${S}/configure"
}

src_install() {
	default

	# useful but too complex to get started; install with docs instead
	dodoc dnsdist.conf-dist
	rm ${D}/etc/${PN}/dnsdist.conf-dist

	# add Gentoo sample config
	insinto /etc/dnsdist
	newins "${FILESDIR}"/dnsdist.conf.example dnsdist.conf

	newconfd "${FILESDIR}"/dnsdist.confd ${PN}
	newinitd "${FILESDIR}"/dnsdist.initd ${PN}
}

pkg_postinst() {
	elog "dnsdist provides multiple instances support. You can create more instances"
	elog "by symlinking the dnsdist init script to another name."
	elog
	elog "The name must be in the format dnsdist.<suffix> and dnsdist will use the"
	elog "/etc/dnsdist/dnsdist-<suffix>.conf configuration file instead of the default."
}
