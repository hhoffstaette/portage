# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.2

EAPI=8

CRATES="
	abscissa_core@0.7.0
	abscissa_derive@0.7.0
	addr2line@0.21.0
	adler@1.0.2
	aead@0.5.2
	aes256ctr_poly1305aes@0.2.0
	aes@0.8.3
	ahash@0.8.7
	aho-corasick@1.1.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.11
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.5
	anyhow@1.0.79
	arc-swap@1.6.0
	array-init@2.1.0
	async-trait@0.1.77
	autocfg@1.1.0
	awaitable-error@0.1.0
	awaitable@0.4.0
	backoff@0.4.0
	backon@0.4.1
	backtrace@0.3.69
	base64@0.21.7
	base64ct@1.6.0
	binrw@0.13.3
	binrw_derive@0.13.3
	bitflags@1.3.2
	bitflags@2.4.2
	block-buffer@0.10.4
	bstr@1.9.0
	bumpalo@3.14.0
	bytemuck@1.14.1
	byteorder@1.5.0
	bytes@1.5.0
	bytesize@1.3.0
	cached@0.48.1
	cached_proc_macro@0.19.1
	cached_proc_macro_types@0.1.1
	cachedir@0.3.1
	canonical-path@2.0.2
	cc@1.0.83
	cfg-if@0.1.10
	cfg-if@1.0.0
	chrono@0.4.33
	cipher@0.4.4
	clap@4.4.18
	clap_builder@4.4.18
	clap_complete@4.4.10
	clap_derive@4.4.7
	clap_lex@0.6.0
	color-eyre@0.6.2
	colorchoice@1.0.0
	comfy-table@7.1.0
	concurrent_arena@0.1.8
	console@0.15.8
	const-oid@0.9.6
	const-random-macro@0.1.16
	const-random@0.1.17
	convert_case@0.4.0
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	cpufeatures@0.2.12
	crc32fast@1.3.2
	crossbeam-channel@0.5.11
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.19
	crossbeam@0.8.4
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	crunchy@0.2.2
	crypto-common@0.1.6
	ctr@0.9.2
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.1
	darling@0.14.4
	darling@0.20.5
	darling_core@0.14.4
	darling_core@0.20.5
	darling_macro@0.14.4
	darling_macro@0.20.5
	data-encoding@2.5.0
	dav-server@0.5.8
	der@0.7.8
	deranged@0.3.11
	derivative@2.2.0
	derive_destructure2@0.1.2
	derive_more@0.99.17
	derive_setters@0.1.6
	dialoguer@0.11.0
	diff@0.1.13
	digest@0.10.7
	dircmp@0.2.0
	directories@5.0.1
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.4
	dlv-list@0.5.2
	duct@0.13.7
	dunce@1.0.4
	ed25519-dalek@2.1.0
	ed25519@2.2.3
	either@1.9.0
	encode_unicode@0.3.6
	encoding_rs@0.8.33
	enum-map-derive@0.17.0
	enum-map@2.7.3
	equivalent@1.0.1
	errno@0.3.8
	eyre@0.6.12
	fastrand@1.9.0
	fastrand@2.0.1
	fiat-crypto@0.2.5
	filetime@0.2.23
	flagset@0.4.4
	flate2@1.0.28
	fnv@1.0.7
	form_urlencoded@1.2.1
	fs-err@2.11.0
	fs_extra@1.3.0
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.2
	futures-util@0.3.30
	futures@0.3.30
	generic-array@0.14.7
	gethostname@0.4.3
	getrandom@0.2.12
	gimli@0.28.1
	glob@0.3.1
	globset@0.4.14
	h2@0.3.24
	hashbrown@0.12.3
	hashbrown@0.14.3
	headers-core@0.2.0
	headers@0.3.9
	heck@0.4.1
	hermit-abi@0.3.4
	hex@0.4.3
	hmac@0.12.1
	home@0.5.9
	htmlescape@0.3.1
	http-body@0.4.6
	http@0.2.11
	httparse@1.8.0
	httpdate@1.0.3
	humantime@2.1.0
	hyper-rustls@0.24.2
	hyper@0.14.28
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.59
	ident_case@1.0.1
	idna@0.5.0
	ignore@0.4.22
	indenter@0.3.3
	indexmap@1.9.3
	indexmap@2.2.2
	indicatif@0.17.7
	inout@0.1.3
	instant@0.1.12
	integer-sqrt@0.1.5
	ipnet@2.9.0
	itertools@0.12.1
	itoa@1.0.10
	jemalloc-sys@0.3.2
	jemallocator-global@0.3.2
	jemallocator@0.3.2
	jobserver@0.1.27
	js-sys@0.3.67
	jsonwebtoken@9.2.0
	lazy_static@1.4.0
	libc@0.2.153
	libm@0.2.8
	libmimalloc-sys@0.1.35
	libredox@0.0.1
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.20
	matchers@0.1.0
	md-5@0.10.6
	memchr@2.7.1
	merge@0.1.0
	merge_derive@0.1.0
	mimalloc@0.1.39
	mime@0.3.17
	mime_guess@2.0.4
	miniz_oxide@0.7.1
	mio@0.8.10
	multer@2.1.0
	nix@0.27.1
	nu-ansi-term@0.46.0
	num-bigint-dig@0.8.4
	num-bigint@0.4.4
	num-conv@0.1.0
	num-derive@0.3.3
	num-integer@0.1.45
	num-iter@0.1.43
	num-traits@0.2.17
	num_cpus@1.16.0
	num_threads@0.1.6
	number_prefix@0.4.0
	object@0.32.2
	once_cell@1.19.0
	opaque-debug@0.3.0
	opendal@0.44.2
	openssh-sftp-client-lowlevel@0.6.0
	openssh-sftp-client@0.14.1
	openssh-sftp-error@0.4.0
	openssh-sftp-protocol-error@0.1.0
	openssh-sftp-protocol@0.24.0
	openssh@0.10.3
	openssl-probe@0.1.5
	option-ext@0.2.0
	ordered-multimap@0.7.1
	os_pipe@1.1.5
	overload@0.1.1
	owo-colors@3.5.0
	pariter@0.5.1
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	path-dedot@3.1.1
	pbkdf2@0.12.2
	pem-rfc7468@0.7.0
	pem@3.0.3
	percent-encoding@2.3.1
	pin-project-internal@1.1.4
	pin-project-lite@0.2.13
	pin-project@1.1.4
	pin-utils@0.1.0
	pkcs1@0.7.5
	pkcs8@0.10.2
	pkg-config@0.3.29
	platforms@3.3.0
	poly1305@0.8.0
	portable-atomic@1.6.0
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	pretty_assertions@1.4.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.78
	quick-xml@0.23.1
	quick-xml@0.30.0
	quick-xml@0.31.0
	quick_cache@0.4.1
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.8.1
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex-automata@0.1.10
	regex-automata@0.4.5
	regex-syntax@0.6.29
	regex-syntax@0.8.2
	regex@1.10.3
	relative-path@1.9.2
	reqsign@0.14.7
	reqwest@0.11.24
	rhai@1.17.1
	rhai_codegen@2.0.0
	ring@0.17.7
	rsa@0.9.6
	rstest@0.18.2
	rstest_macros@0.18.2
	runtime-format@0.1.3
	rust-ini@0.20.0
	rustc-demangle@0.1.23
	rustc_version@0.4.0
	rustic_backend@0.1.1
	rustic_core@0.2.0
	rustix@0.38.31
	rustls-native-certs@0.6.3
	rustls-pemfile@1.0.4
	rustls-webpki@0.101.7
	rustls@0.21.10
	rustversion@1.0.14
	ryu@1.0.16
	salsa20@0.10.2
	same-file@1.0.6
	schannel@0.1.23
	scoped-tls@1.0.1
	scopeguard@1.2.0
	scrypt@0.11.0
	sct@0.7.1
	secrecy@0.8.0
	security-framework-sys@2.9.1
	security-framework@2.9.2
	self-replace@1.3.7
	self_update@0.39.0
	semver@1.0.21
	serde-aux@4.4.0
	serde@1.0.196
	serde_derive@1.0.196
	serde_json@1.0.113
	serde_spanned@0.6.5
	serde_urlencoded@0.7.1
	serde_with@3.6.0
	serde_with_macros@3.6.0
	sha1@0.10.6
	sha2-asm@0.6.3
	sha2@0.10.8
	sharded-slab@0.1.7
	shared_child@1.0.0
	shell-escape@0.1.5
	shell-words@1.1.0
	signal-hook-registry@1.4.1
	signature@2.2.0
	simple_asn1@0.6.2
	simplelog@0.12.1
	slab@0.4.9
	smallvec@1.13.1
	smartstring@1.0.1
	socket2@0.5.5
	spin@0.5.2
	spin@0.9.8
	spki@0.7.3
	ssh_format@0.14.1
	ssh_format_error@0.1.0
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	strsim@0.10.0
	strum@0.25.0
	strum@0.26.1
	strum_macros@0.25.3
	strum_macros@0.26.1
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.48
	sync_wrapper@0.1.2
	synstructure@0.12.6
	system-configuration-sys@0.5.0
	system-configuration@0.5.1
	tar@0.4.40
	tempfile@3.9.0
	termcolor@1.1.3
	terminal_size@0.3.0
	thin-vec@0.2.13
	thiserror-impl@1.0.56
	thiserror@1.0.56
	thread_local@1.1.7
	time-core@0.1.2
	time-macros@0.2.17
	time@0.3.33
	tiny-keccak@2.0.2
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-io-utility@0.7.6
	tokio-macros@2.2.0
	tokio-pipe@0.2.12
	tokio-rustls@0.24.1
	tokio-stream@0.1.14
	tokio-tungstenite@0.20.1
	tokio-util@0.7.10
	tokio@1.36.0
	toml@0.5.11
	toml@0.8.9
	toml_datetime@0.6.5
	toml_edit@0.21.1
	tower-service@0.3.2
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.1.4
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing@0.1.40
	triomphe@0.1.11
	try-lock@0.2.5
	tungstenite@0.20.1
	typenum@1.17.0
	unicase@2.7.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	unicode-width@0.1.11
	unicode-xid@0.2.4
	universal-hash@0.5.1
	untrusted@0.9.0
	url@2.5.0
	urlencoding@2.1.3
	utf-8@0.7.6
	utf8parse@0.2.1
	uuid@1.7.0
	valuable@0.1.0
	vec-strings@0.4.8
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.4.0
	want@0.3.1
	warp@0.3.6
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.90
	wasm-bindgen-futures@0.4.40
	wasm-bindgen-macro-support@0.2.90
	wasm-bindgen-macro@0.2.90
	wasm-bindgen-shared@0.2.90
	wasm-bindgen@0.2.90
	wasm-streams@0.4.0
	web-sys@0.3.67
	webpki-roots@0.25.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
	winnow@0.5.37
	winreg@0.50.0
	xattr@1.3.1
	xml-rs@0.8.19
	xmltree@0.10.3
	yansi@0.5.1
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
	zeroize@1.7.0
	zipsign-api@0.1.1
	zstd-safe@7.0.0
	zstd-sys@2.0.9+zstd.1.5.5
	zstd@0.13.0
"

inherit cargo

DESCRIPTION="Fast, encrypted, deduplicated backups powered by pure Rust"
HOMEPAGE="https://github.com/rustic-rs/rustic"
SRC_URI="
	https://github.com/rustic-rs/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD CC0-1.0 ISC MIT
	MPL-2.0 MPL-2.0 Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
