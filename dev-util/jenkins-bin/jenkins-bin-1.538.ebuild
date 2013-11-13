inherit java-pkg-2 rpm

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
LICENSE="MIT"
# We are using rpm package here, because we want file with version.
SRC_URI="http://pkg.jenkins-ci.org/redhat/jenkins-${PV}-1.1.noarch.rpm"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-fonts/dejavu"
RDEPEND="${DEPEND}
        >=virtual/jdk-1.7"

src_unpack() {
    rpm_src_unpack ${A}
}

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
    doins usr/lib/jenkins/jenkins.war

    newinitd "${FILESDIR}/init.sh" jenkins
    newconfd "${FILESDIR}/conf" jenkins

    fowners jenkins:jenkins /run/jenkins
    fowners jenkins:jenkins /var/log/jenkins
    fowners jenkins:jenkins /var/lib/jenkins
    fowners jenkins:jenkins /var/lib/jenkins/backup
    fowners jenkins:jenkins /var/lib/jenkins/home
    fowners jenkins:jenkins /var/tmp/jenkins
}
