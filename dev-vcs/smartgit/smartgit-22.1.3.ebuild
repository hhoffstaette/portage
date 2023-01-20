# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-utils-2

MY_PV=$(ver_rs 1- '_')
S="${WORKDIR}/${PN}"

DESCRIPTION="SmartGit/Hg is a client for Git and Mercurial"
HOMEPAGE="http://www.syntevo.com/smartgithg/"
SRC_URI="http://www.syntevo.com/downloads/smartgit/${PN}-linux-${MY_PV}.tar.gz"

LICENSE="smartgithg"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} >=virtual/jre-1.8.0"

src_install()
{
	local rdir="/opt/${PN}"
	insinto $rdir
	doins -r lib licenses
	insinto $rdir/bin
	insopts -m755
	doins bin/smartgit.sh
	dosym $rdir/bin/smartgit.sh /usr/bin/smartgit
	dodoc changelog.txt known-issues.txt
	for i in 32 48 64 128 256
	do
		newicon -s $i "bin/${PN}-${i}.png" "${PN}.png"
	done
	make_desktop_entry "${PN}" "SmartGit/Hg" "${PN}" "Development;RevisionControl" \
		"GenericName=Git&Hg-Client + SVN-support\nStartupNotify=true\nMimeType=x-scheme-handler/smartgit;\nKeywords=git;hg;svn;mercurial;subversion;"
	sed -e "/^Exec/s/$/ %u/" -i "${D}"/usr/share/applications/*.desktop || die
}
