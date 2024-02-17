# Copyright 1999-2024 Gentoo Authors
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
IUSE="bpf cdb dnscrypt dnstap doh gnutls lmdb quic regex snmp ssl systemd test xdp"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}
		dnscrypt? ( ssl )
		gnutls? ( ssl )
		doh? ( ssl !gnutls )"

RDEPEND="acct-group/dnsdist
	acct-user/dnsdist
	bpf? ( dev-libs/libbpf:= )
	cdb? ( dev-db/cdb )
	dev-libs/boost:=
	dev-libs/libedit:=
	dev-libs/libsodium:=
	dnstap? ( dev-libs/fstrm:= )
	doh? ( net-libs/nghttp2:= )
	lmdb? ( dev-db/lmdb:= )
	quic? ( net-libs/quiche )
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

src_prepare() {
	default

	# clean up duplicate
	rm -f README.md
}

src_configure() {
	# bug #822855
	append-lfs-flags

	econf \
		--sysconfdir=/etc/dnsdist \
		--with-lua="${ELUA}" \
		--without-h2o \
		$(use_with bpf ebpf) \
		$(use_with cdb cdb) \
		$(use_enable dnscrypt) \
		$(use_enable dnstap) \
		$(use_enable doh dns-over-https) \
		$(use_with doh nghttp2) \
		$(use_with lmdb) \
		$(use_enable quic dns-over-http3) \
		$(use_enable quic dns-over-quic) \
		$(use_with quic quiche) \
		$(use_with regex re2) \
		$(use_with snmp net-snmp) \
		$(use ssl && { echo "--enable-dns-over-tls" && use_with gnutls && use_with !gnutls libssl;} || echo "--without-gnutls --without-libssl") \
		$(use_enable systemd) \
		$(use_enable test unit-tests) \
		$(use_with xdp xsk)

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
