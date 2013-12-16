# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="svn://pqxx.org/swapspace/trunk/"
	inherit subversion
fi

DESCRIPTION="A dynamic swap space manager"
HOMEPAGE="http://pqxx.org/development/swapspace/"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="${DEPEND}"

src_compile() {
	emake CFLAGS="${CFLAGS} -std=gnu99" || die "Make failed!"
}

src_install() {
	newconfd "${FILESDIR}/swapspace.confd" ${PN}
	newinitd "${FILESDIR}/swapspace.initd" ${PN}

	# insinto /usr/sbin
	dosbin "${S}"/src/swapspace

	insinto /etc
	doins swapspace.conf

	doman "${S}"/doc/swapspace.8

	dodoc COPYING README

	diropts -m 0700
	keepdir /var/lib/swapspace
}
