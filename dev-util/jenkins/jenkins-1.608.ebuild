# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
LICENSE="MIT"
SRC_URI="http://mirrors.jenkins-ci.org/war/${PV}/${PN}.war -> ${P}.war"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-fonts/dejavu"
RDEPEND="${DEPEND}
	media-libs/freetype
	!dev-util/jenkins-bin:lts
	>=virtual/jdk-1.7"

S=${WORKDIR}

pkg_setup() {
    enewgroup jenkins
    enewuser jenkins -1 /bin/bash /var/lib/jenkins jenkins
}

src_install() {
    keepdir /run/jenkins
    keepdir /var/log/jenkins
    keepdir /var/lib/jenkins/backup
    keepdir /var/lib/jenkins/home
    keepdir /var/tmp/jenkins

    insinto /usr/lib/jenkins
	newins "${DISTDIR}"/${P}.war ${PN}.war

    newinitd "${FILESDIR}/init.sh" jenkins
    newconfd "${FILESDIR}/conf" jenkins

    fowners jenkins:jenkins /run/jenkins
    fowners jenkins:jenkins /var/log/jenkins
    fowners jenkins:jenkins /var/lib/jenkins
    fowners jenkins:jenkins /var/lib/jenkins/backup
    fowners jenkins:jenkins /var/lib/jenkins/home
    fowners jenkins:jenkins /var/tmp/jenkins
}
