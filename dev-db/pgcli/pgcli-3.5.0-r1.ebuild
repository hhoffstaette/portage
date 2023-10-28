# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="CLI for Postgres with auto-completion and syntax highlighting"
HOMEPAGE="https://www.pgcli.com https://github.com/dbcli/pgcli"
SRC_URI="https://github.com/dbcli/pgcli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cli-helpers[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pendulum[${PYTHON_USEDEP}]
	>=dev-python/pgspecial-2.0.0[${PYTHON_USEDEP}]
	dev-python/prompt-toolkit[${PYTHON_USEDEP}]
	>=dev-python/psycopg-3.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/sqlparse[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-db/postgresql
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/3.5.0-fix-sql-insert-format-emits-NULL-as-None.patch" )

distutils_enable_tests pytest
