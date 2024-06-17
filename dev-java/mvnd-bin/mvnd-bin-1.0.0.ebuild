# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV}"
MY_MV="${PV%%.*}"

DESCRIPTION="Apache Maven Daemon"
HOMEPAGE="https://github.com/apache/maven-mvnd https://maven.apache.org/"
SRC_URI="https://github.com/apache/maven-mvnd/releases/download/${PV}/maven-${MY_P}-linux-amd64.tar.gz"

S="${WORKDIR}/maven-${MY_P}-linux-amd64"

LICENSE="Apache-2.0"
SLOT="3.9"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
	app-eselect/eselect-java"

RDEPEND="
	>=virtual/jre-1.8:*"

MAVEN="${PN}-${SLOT}"
MAVEN_SHARE="/usr/share/${MAVEN}"

src_install() {
	dodir "${MAVEN_SHARE}"

	# not needed
	rm -rf mvn/lib/jansi-native

	cp -Rp bin conf mvn "${ED}/${MAVEN_SHARE}" || die "failed to copy"

	dodoc NOTICE.txt README.adoc

	dodir /usr/bin
	dosym "${MAVEN_SHARE}/bin/mvnd" "${EPREFIX}/usr/bin/mvnd-${SLOT}"

	# Protect both mvnd and mvn configs, see bug #342901
	echo "CONFIG_PROTECT=\"${MAVEN_SHARE}/conf ${MAVEN_SHARE}/mvn/conf\"" > "${T}/25${MAVEN}" || die
	doenvd "${T}/25${MAVEN}"
}

pkg_postinst() {
	eselect maven update ${MY_P}
}

pkg_postrm() {
	eselect maven update
}
