# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator

DESCRIPTION="A library that provides an embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-bzip2 -java lz4 -numa -snappy zlib zstd"

RDEPEND="
	bzip2? ( app-arch/bzip2 )
	dev-cpp/gflags
	dev-libs/jemalloc
	java? ( virtual/jdk )
	lz4? ( app-arch/lz4 )
	numa? ( sys-process/numactl )
	snappy? ( app-arch/snappy )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )
"

DEPEND="${RDEPEND}"

# versioning is hard
[[ $(get_version_component_count) == 2 ]] && MICROVERSION=".0"

# this trainwreck doesn't even build with its own default flags, so help it along
EXTRA_FLAGS="DEBUG_LEVEL=0 DISABLE_WARNING_AS_ERROR=1"
EXTRA_CXXFLAGS=""

src_prepare() {
	# apply patches
	epatch "${FILESDIR}"/*.patch
	epatch_user

	# we need to build some of the jars ourselves, so we define
	# their names from shared prefixes
	ROCKSDB_JNI=rocksdbjni-${PV}${MICROVERSION}
	ROCKSDB_JAR=${ROCKSDB_JNI}-linux$(getconf LONG_BIT).jar
	ROCKSDB_JAVADOCS_JAR=${ROCKSDB_JNI}-javadocs.jar
	ROCKSDB_SOURCES_JAR=${ROCKSDB_JNI}-sources.jar
}

src_compile() {
	# by default we build only the shared lib
	emake ${EXTRA_FLAGS} ${EXTRA_CXXFLAGS} shared_lib

	# building Java support is optional
	if use java ; then

		# this builds the JNI jar where the embedded JNI library
		# has dependencies to externally installed bzip/lz4/snappy.
		emake ${EXTRA_FLAGS} ${EXTRA_CXXFLAGS} rocksdbjava

		# WTF: we need to manually create IDE-attachable support jars
		# because those are built by the wrong Makefile target.

		# first the javadocs
	    pushd java/target/apidocs
	    jar -cf ../${ROCKSDB_JAVADOCS_JAR} *
	    popd

	    # now the sources
	    pushd java/src/main/java
		jar -cf ../../../target/${ROCKSDB_SOURCES_JAR} org
		popd
	fi
}

src_install() {
	emake ${EXTRA_FLAGS} ${EXTRA_CXXFLAGS} INSTALL_PATH="${D}/usr" install-shared

	dodoc README.md

	if use java ; then
		insinto /usr/lib/${PN}
		doins java/target/${ROCKSDB_JAR}
		doins java/target/${ROCKSDB_JAVADOCS_JAR}
		doins java/target/${ROCKSDB_SOURCES_JAR}
	fi
}
