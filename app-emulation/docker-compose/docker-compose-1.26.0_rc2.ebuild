# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"

MY_EXE="${PN}-Linux-x86_64"
MY_PV="${PV/_/-}"

SRC_URI="https://github.com/docker/compose/archive/${MY_PV}.tar.gz -> ${P}.tar.gz \
	https://github.com/docker/compose/releases/download/${MY_PV}/${MY_EXE}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
RDEPEND=""
DEPEND="${RDEPEND}"

QA_PREBUILT="/usr/bin/${PN}"
QA_PRESTRIPPED=${QA_PREBUILT}

S="${WORKDIR}/compose-${MY_PV}"

src_prepare() {
	# Address QA issue "docker-compose.exe: missing alias (symlink) for completed command."
	sed 's,^\(complete.*\) docker-compose\.exe\(.*\),\1\2,' -i contrib/completion/bash/docker-compose || die

	default
}

src_install() {
	newbashcomp contrib/completion/bash/docker-compose ${PN}

	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/*

	newbin ${DISTDIR}/${MY_EXE} ${PN}
}

