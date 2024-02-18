# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.10

EAPI=8

CRATES="
	aho-corasick@0.7.15
	autocfg@1.0.1
	base64@0.13.0
	bitflags@1.2.1
	byteorder@1.4.3
	bytes@0.5.6
	bytes@1.1.0
	cfg-if@0.1.10
	cfg-if@1.0.0
	chrono@0.4.19
	dns-message-parser@0.6.0
	etherparse@0.9.0
	eyre@0.6.5
	fnv@1.0.7
	fuchsia-zircon-sys@0.3.3
	fuchsia-zircon@0.3.3
	futures-channel@0.3.13
	futures-core@0.3.13
	futures-executor@0.3.13
	futures-io@0.3.13
	futures-macro@0.3.13
	futures-sink@0.3.13
	futures-task@0.3.13
	futures-util@0.3.13
	futures@0.3.13
	getopts@0.2.21
	hermit-abi@0.1.18
	hex@0.4.3
	indenter@0.3.3
	iovec@0.1.4
	kernel32-sys@0.2.2
	lazy_static@1.4.0
	libc@0.2.91
	libloading@0.6.7
	log@0.4.14
	memchr@2.3.4
	mio-named-pipes@0.1.7
	mio-uds@0.6.8
	mio@0.6.23
	miow@0.2.2
	miow@0.3.7
	net2@0.2.37
	num-integer@0.1.44
	num-traits@0.2.14
	num_cpus@1.13.0
	once_cell@1.7.2
	pin-project-lite@0.1.12
	pin-project-lite@0.2.6
	pin-utils@0.1.0
	proc-macro-hack@0.5.19
	proc-macro-nested@0.1.7
	proc-macro2@1.0.24
	quote@1.0.9
	regex-syntax@0.6.23
	regex@1.4.5
	signal-hook-registry@1.3.0
	slab@0.4.2
	syn@1.0.65
	thiserror-impl@1.0.30
	thiserror@1.0.30
	time@0.1.44
	tokio-macros@0.2.6
	tokio@0.2.25
	unicode-width@0.1.8
	unicode-xid@0.2.1
	wasi@0.10.0+wasi-snapshot-preview1
	widestring@0.2.2
	winapi-build@0.1.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.2.8
	winapi@0.3.9
	ws2_32-sys@0.2.1
"

declare -A GIT_CRATES=(
	[pcap]='https://github.com/jvns/pcap;ae2aa7f501ae5bb7069155cf7c5c700b7482681d;pcap-%commit%'
)

inherit cargo

DESCRIPTION="Spy on the DNS queries your computer is making"
HOMEPAGE="https://github.com/jvns/dnspeep"
SRC_URI="
	https://github.com/jvns/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" BSD ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
