# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A library that provides an embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org"
SRC_URI="https://github.com/facebook/${PN}/archive/${P}.tar.gz"
PATCH_VERSION=0

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-java"

RDEPEND="
	app-arch/bzip2
	app-arch/snappy
	dev-cpp/gflags
	java? ( virtual/jdk )
	sys-libs/zlib
"

DEPEND="${RDEPEND}"

ROCKSDB_JNI=rocksdbjni-${PV}.${PATCH_VERSION}
ROCKSDB_JAR=${ROCKSDB_JNI}-linux$(getconf LONG_BIT).jar
ROCKSDB_JAVADOCS_JAR=${ROCKSDB_JNI}-javadocs.jar
ROCKSDB_SOURCES_JAR=${ROCKSDB_JNI}-sources.jar

EXTRA_FLAGS="DEBUG_LEVEL=0 EXTRA_CXXFLAGS=-Wno-error=unused-variable"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/*.patch
}

src_compile() {
	emake ${EXTRA_FLAGS} shared_lib

	if use java ; then
		emake ${EXTRA_FLAGS} rocksdbjava

		# create javadocs
	    pushd java/target/apidocs
	    jar -cf ../${ROCKSDB_JAVADOCS_JAR} *
	    popd

	    # create source jar
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
