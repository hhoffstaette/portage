# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.14.0

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[criterion-plot]='https://github.com/bheisler/criterion.rs;b913e232edd98780961ecfbae836ec77ede49259;criterion.rs-%commit%/plot'
	[criterion]='https://github.com/bheisler/criterion.rs;b913e232edd98780961ecfbae836ec77ede49259;criterion.rs-%commit%'
	[vmlinux]='https://github.com/libbpf/vmlinux.h;a9c092aa771310bf8b00b5018f7d40a1fdb6ec82;vmlinux.h-%commit%'
)

inherit cargo

DESCRIPTION="C bindings for blazesym"
HOMEPAGE="https://github.com/libbpf/blazesym"
SRC_URI="
	https://github.com/libbpf/blazesym/archive/refs/tags/capi-v${PV}.tar.gz -> ${P}.tar.gz
	https://www.applied-asynchrony.com/distfiles/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		blazesym_c-0.1.1-crates.tar.xz
	"
fi

LICENSE="BSD"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0 ISC
	MIT MPL-2.0 Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-util/cargo-c
"

# build in the capi subdirectory since cargo has no -C option:
# https://github.com/rust-lang/cargo/issues/10098
S="${WORKDIR}/blazesym-capi-v${PV}/capi"

src_prepare() {
	default

	# make blazesym aware of cargo-c
	# https://github.com/libbpf/blazesym/issues/1096
	# https://github.com/lu-zero/cargo-c/issues/452
	eapply -p2 "${FILESDIR}/0.1.1-add-capi-feature-to-enable-building-with-cargo-c.patch"
}

src_configure() {
	CARGO_ARGS=(
		--library-type=cdylib
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		--destdir="${ED}"
		$(usev !debug '--release')
	)

	cargo_src_configure
}

src_compile() {
	cargo cbuild "${CARGO_ARGS[@]}" || die
}

src_install() {
	cargo cinstall "${CARGO_ARGS[@]}" || die
}
