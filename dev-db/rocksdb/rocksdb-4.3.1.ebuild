# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A library that provides an embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org"
SRC_URI="https://github.com/facebook/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-java"

RDEPEND="
	app-arch/bzip2
	app-arch/lz4
	app-arch/snappy
	dev-cpp/gflags
	java? ( virtual/jdk )
	sys-libs/zlib
"

DEPEND="${RDEPEND}"

# we need to build some of the jars ourselves, so we define
# their names from shared prefixes
ROCKSDB_JNI=rocksdbjni-${PV}
ROCKSDB_JAR=${ROCKSDB_JNI}-linux$(getconf LONG_BIT).jar
ROCKSDB_JAVADOCS_JAR=${ROCKSDB_JNI}-javadocs.jar
ROCKSDB_SOURCES_JAR=${ROCKSDB_JNI}-sources.jar

# this trainwreck doesn't even build with its own default flags,
# so help it along
EXTRA_FLAGS="DEBUG_LEVEL=0 EXTRA_CXXFLAGS=-Wno-error=unused-variable"

# yes, the directory is called rocksdb-rocksdb-x.y
S="${WORKDIR}/${PN}-${PN}-${PV}"

src_prepare() {
	# apply patches
	epatch "${FILESDIR}"/${PN}-${PV}-*.patch
	epatch_user
}

src_compile() {
	# by default we build only the shared lib
	emake ${EXTRA_FLAGS} shared_lib

	# building Java support is optional
	if use java ; then
		# this builds the JNI jar where the embedded JNI library
		# has dependencies to externally installed bzip/lz4/snappy.
		emake ${EXTRA_FLAGS} rocksdbjava

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
	emake ${EXTRA_FLAGS} INSTALL_PATH="${D}/usr" install-shared

	dodoc README.md

	if use java ; then
		insinto /usr/lib/${PN}
		doins java/target/${ROCKSDB_JAR}
		doins java/target/${ROCKSDB_JAVADOCS_JAR}
		doins java/target/${ROCKSDB_SOURCES_JAR}
	fi
}
