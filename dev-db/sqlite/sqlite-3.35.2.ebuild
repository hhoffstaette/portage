# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

SRC_PV="$(printf "%u%02u%02u%02u" $(ver_rs 1- " "))"
DOC_PV="${SRC_PV}"

DESCRIPTION="SQL database engine"
HOMEPAGE="https://sqlite.org/"
SRC_URI="https://sqlite.org/2021/${PN}-autoconf-${SRC_PV}.tar.gz
	doc? ( https://sqlite.org/2021/${PN}-doc-${DOC_PV}.zip )"

LICENSE="public-domain"
SLOT="3"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 riscv s390 sparc x86 amd64-linux x86-linux ppc-macos x64-macos x86-macos m68k-mint sparc-solaris sparc64-solaris x64-solaris x86-solaris"

IUSE="debug doc icu +readline secure-delete static-libs"

RESTRICT="test"

BDEPEND="doc? ( app-arch/unzip )"

RDEPEND="sys-libs/zlib:0=[${MULTILIB_USEDEP}]
	icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline:0=[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}"

pkg_setup() {
	S="${WORKDIR}/${PN}-autoconf-${SRC_PV}"
}

src_unpack() {
	default
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-3.25.0-nonfull_archive-build.patch"
	eapply_user

	# Fix AC_CHECK_FUNCS.
	# https://mailinglists.sqlite.org/cgi-bin/mailman/private/sqlite-dev/2016-March/002762.html
	sed \
		-e "s/AC_CHECK_FUNCS(\[fdatasync.*/AC_CHECK_FUNCS([fdatasync fullfsync gmtime_r isnan localtime_r localtime_s malloc_usable_size posix_fallocate pread pread64 pwrite pwrite64 strchrnul usleep utime])/" \
		-e "/AC_CHECK_FUNCS(posix_fallocate)/d" \
		-i configure.ac || die "sed failed"

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local -x CPPFLAGS="${CPPFLAGS}" CFLAGS="${CFLAGS}"
	local options=()

	options+=(
		--enable-threadsafe
		--disable-static-shell
	)

	# Support detection of misuse of SQLite API.
	# https://sqlite.org/compile.html#enable_api_armor
	append-cppflags -DSQLITE_ENABLE_API_ARMOR

	# Support bytecode and tables_used virtual tables.
	# https://sqlite.org/bytecodevtab.html
	append-cppflags -DSQLITE_ENABLE_BYTECODE_VTAB

	# Support column metadata functions.
	# https://sqlite.org/c3ref/column_database_name.html
	append-cppflags -DSQLITE_ENABLE_COLUMN_METADATA

	# Support sqlite_dbpage virtual table.
	# https://sqlite.org/dbpage.html
	append-cppflags -DSQLITE_ENABLE_DBPAGE_VTAB

	# Support dbstat virtual table.
	# https://sqlite.org/dbstat.html
	append-cppflags -DSQLITE_ENABLE_DBSTAT_VTAB

	# Support sqlite3_serialize() and sqlite3_deserialize() functions.
	# https://sqlite.org/c3ref/serialize.html
	# https://sqlite.org/c3ref/deserialize.html
	append-cppflags -DSQLITE_ENABLE_DESERIALIZE

	# Support comments in output of EXPLAIN.
	# https://sqlite.org/compile.html#enable_explain_comments
	append-cppflags -DSQLITE_ENABLE_EXPLAIN_COMMENTS

	# Support Full-Text Search versions 3, 4 and 5.
	# https://sqlite.org/fts3.html
	# https://sqlite.org/fts5.html
	append-cppflags -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4
	options+=(--enable-fts5)

	# Support hidden columns.
	append-cppflags -DSQLITE_ENABLE_HIDDEN_COLUMNS

	# Support JSON1 extension.
	# https://sqlite.org/json1.html
	append-cppflags -DSQLITE_ENABLE_JSON1

	# Support memsys5 memory allocator.
	# https://sqlite.org/malloc.html#memsys5
	append-cppflags -DSQLITE_ENABLE_MEMSYS5

	# Support sqlite3_normalized_sql() function.
	# https://sqlite.org/c3ref/expanded_sql.html
	append-cppflags -DSQLITE_ENABLE_NORMALIZE

	# Support sqlite_offset() function.
	# https://sqlite.org/lang_corefunc.html#sqlite_offset
	append-cppflags -DSQLITE_ENABLE_OFFSET_SQL_FUNC

	# Support pre-update hook functions.
	# https://sqlite.org/c3ref/preupdate_count.html
	append-cppflags -DSQLITE_ENABLE_PREUPDATE_HOOK

	# Support Resumable Bulk Update extension.
	# https://sqlite.org/rbu.html
	append-cppflags -DSQLITE_ENABLE_RBU

	# Support R*Trees.
	# https://sqlite.org/rtree.html
	# https://sqlite.org/geopoly.html
	append-cppflags -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_GEOPOLY

	# Support scan status functions.
	# https://sqlite.org/c3ref/stmt_scanstatus.html
	# https://sqlite.org/c3ref/stmt_scanstatus_reset.html
	append-cppflags -DSQLITE_ENABLE_STMT_SCANSTATUS

	# Support sqlite_stmt virtual table.
	# https://sqlite.org/stmt.html
	append-cppflags -DSQLITE_ENABLE_STMTVTAB

	# Support Session extension.
	# https://sqlite.org/sessionintro.html
	options+=(--enable-session)

	# Support unknown() function.
	# https://sqlite.org/compile.html#enable_unknown_sql_function
	append-cppflags -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION

	# Support unlock notification.
	# https://sqlite.org/unlock_notify.html
	append-cppflags -DSQLITE_ENABLE_UNLOCK_NOTIFY

	# Support LIMIT and ORDER BY clauses on DELETE and UPDATE statements.
	# https://sqlite.org/lang_delete.html#optional_limit_and_order_by_clauses
	# https://sqlite.org/lang_update.html#optional_limit_and_order_by_clauses
	append-cppflags -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT

	# Support soundex() function.
	# https://sqlite.org/lang_corefunc.html#soundex
	append-cppflags -DSQLITE_SOUNDEX

	# Support URI filenames.
	# https://sqlite.org/uri.html
	append-cppflags -DSQLITE_USE_URI

	# debug USE flag.
	if use debug; then
		append-cppflags -DSQLITE_DEBUG
	else
		append-cppflags -DNDEBUG
	fi

	# icu USE flag.
	if use icu; then
		# Support ICU extension.
		# https://sqlite.org/compile.html#enable_icu
		append-cppflags -DSQLITE_ENABLE_ICU
		sed -e "s/^LIBS = @LIBS@/& -licui18n -licuuc/" -i Makefile.in || die "sed failed"
	fi

	# readline USE flag.
	options+=(
		--disable-editline
		$(use_enable readline)
	)

	# secure-delete USE flag.
	if use secure-delete; then
		# Enable secure_delete pragma by default.
		# https://sqlite.org/pragma.html#pragma_secure_delete
		append-cppflags -DSQLITE_SECURE_DELETE
	fi

	# static-libs USE flag.
	options+=($(use_enable static-libs static))

	if [[ "${CHOST}" == *-mint* ]]; then
		append-cppflags -DSQLITE_OMIT_WAL
	fi

	if [[ "${ABI}" == "x86" ]]; then
		if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} -E -P -dM - < /dev/null 2> /dev/null | grep -q "^#define __SSE__ 1$"; then
			append-cflags -mfpmath=sse
		else
			append-cflags -ffloat-store
		fi
	fi

	econf "${options[@]}"
}

multilib_src_compile() {
	emake HAVE_TCL=0
}

multilib_src_install() {
	emake DESTDIR="${D}" HAVE_TCL=0 install
}

multilib_src_install_all() {
	find "${D}" -name "*.la" -type f -delete || die

	doman sqlite3.1

	if use doc; then
		rm "${WORKDIR}/${PN}-doc-${DOC_PV}/"*.{db,txt} || die
		(
			docinto html
			dodoc -r "${WORKDIR}/${PN}-doc-${DOC_PV}/"*
		)
	fi
}
