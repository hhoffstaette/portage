# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Nexus Maven Repository Server"
KEYWORDS="amd64 x86"
SLOT="0"

MY_PN=${PN/nexus-bin/nexus}
MY_PV=$(ver_rs 3 -)
SRC_URI="http://download.sonatype.com/nexus/oss/${MY_PN}-${MY_PV}-bundle.tar.gz"

IUSE=""

DEPEND="acct-group/nexus
        acct-user/nexus
		virtual/jdk:1.8"

RDEPEND="virtual/jre:1.8"

S=${WORKDIR}/${MY_PN}-${MY_PV}

NEXUS_HOME=/usr/share/nexus
NEXUS_DATA=/var/lib/nexus

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_install() {
	cd "${S}/bin/jsw"

	case ${ARCH} in
	x86)   F_ARCH="linux-x86-32" ;;
	amd64) F_ARCH="linux-x86-64" ;;
	*) die "This ebuild doesn't support ${ARCH}." ;;
    esac

	# clean out unneeded binaries, but keep conf & lib
	ls | grep -v $F_ARCH | grep -v conf | grep -v lib | xargs rm -R || die "remove failed"

	# clean out unneeded libraries
	cd lib
	ls | grep -v libwrapper-$F_ARCH | grep -v *.jar | xargs rm -R || die "remove in lib failed"

	dodir ${NEXUS_HOME}

	diropts -m775 -o nexus -g nexus
	keepdir /etc/nexus
	keepdir ${NEXUS_DATA}
	keepdir /var/log/nexus/

	dosym /etc/nexus ${NEXUS_HOME}/conf
	dosym /var/log/nexus ${NEXUS_HOME}/logs
	dosym /var/tmp/nexus ${NEXUS_HOME}/tmp
	dosym /var/log/nexus ${NEXUS_DATA}/logs
	dosym /var/tmp/nexus ${NEXUS_DATA}/tmp

	# bind only to localhost
	sed -i -e 's:application-host=0.0.0.0:application-host=127.0.0.1:' "${S}"/conf/nexus.properties

	# change working dir to /var/lib/nexus aka NEXUS_DATA
	sed -i -e 's:nexus-work=\${bundleBasedir}/../sonatype-work/nexus:nexus-work=/var/lib/nexus:' "${S}"/conf/nexus.properties

	cd "${S}"
	chown -R nexus:nexus nexus/*
	cp -pPR conf/* bin/jsw/conf/wrapper.conf "${D}/etc/nexus" || die "failed to copy conf"
	rm -rf bin/jsw/conf bin/nexus bin/nexus.bat  || die "failed to clean up bin"
	cp -pPR bin lib nexus "${D}${NEXUS_HOME}" || die "failed to copy nexus"

	newinitd "${FILESDIR}"/nexus.init nexus

	elog "Nexus storage is /var/lib/nexus. Ensure that there is enough space."

	elog "The default password for user admin is admin123."

	ewarn "For security reasons nexus is bound to localhost."
	ewarn "Before binding to public ip or mapping with mod_jk, please change passwords."
}
