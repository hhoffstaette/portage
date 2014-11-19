
EAPI=5

inherit versionator java-utils-2

MY_PV=$(replace_all_version_separators '_')
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="SmartGit/Hg is a client for Git and Mercurial"
HOMEPAGE="http://www.syntevo.com/smartgithg/"
SRC_URI="http://www.syntevo.com/download/${PN}/${PN}-generic-${MY_PV}.tar.gz"

LICENSE="smartgithg"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} >=virtual/jre-1.6.0"

src_install()
{
	local rdir="/opt/${PN}"
	insinto "$rdir"
	doins -r lib licenses
	java-pkg_regjar "${D}/${rdir}"/lib/*.jar
	java-pkg_dolauncher "${PN}" --java_args "-Xmx256m -Dsun.io.useCanonCaches=false -Xverify:none -Dsmartgit.vm-xmx=256m" --jar bootloader.jar

	dodoc changelog.txt known-issues.txt
	for i in 32 48 64 128 256
	do
		newicon -s $i "bin/${PN}-${i}.png" "${PN}.png"
	done
	make_desktop_entry "${PN}" "SmartGit/Hg" "${PN}" "Development;RevisionControl" \
		"GenericName=Git&Hg-Client + SVN-support\nStartupNotify=true\nMimeType=x-scheme-handler/smartgit;\nKeywords=git;hg;svn;mercurial;subversion;"
	sed -e "/^Exec/s/$/ %u/" -i "${D}"/usr/share/applications/*.desktop || die
}
