# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic pam tmpfiles

DESCRIPTION="screen manager with VT100/ANSI terminal emulation"
HOMEPAGE="https://www.gnu.org/software/screen/"

if [[ ${PV} != 9999 ]] ; then
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
else
	inherit git-r3
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/screen.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}" # needed for setting S later on
	S="${WORKDIR}"/${P}/src
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug pam selinux utempter multiuser"
# bug #956963
RESTRICT="test"

DEPEND=">=sys-libs/ncurses-5.2:=
	virtual/libcrypt:=
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	acct-group/utmp
	selinux? ( sec-policy/selinux-screen )
	utempter? ( sys-libs/libutempter:= )"
BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/5.0.0-utmp-musl.patch
	"${FILESDIR}"/5.0.1-texinfo.patch
)

src_prepare() {
	default

	# sched.h is a system header and causes problems with some C libraries
	mv sched.h _sched.h || die
	sed -i '/include/ s:sched.h:_sched.h:' canvas.h sched.c screen.h window.h winmsg.c || die
	sed -i 's:sched.h:_sched.h:' Makefile.in || die

	# Fix manpage
	sed -i \
		-e "s:/usr/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/usr/local/screens:${EPREFIX}/run/screen:g" \
		-e "s:/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/etc/utmp:${EPREFIX}/var/run/utmp:g" \
		-e "s:/local/screens/S\\\-:${EPREFIX}/run/screen/S\\\-:g" \
		doc/screen.1 || die

	# reconfigure
	eautoreconf
}

src_configure() {
	append-lfs-flags
	append-cppflags "-DMAXWIN=${MAX_SCREEN_WINDOWS:-100}"

	if [[ ${CHOST} == *-solaris* ]]; then
		# enable msg_header by upping the feature standard compatible
		# with c99 mode
		append-cppflags -D_XOPEN_SOURCE=600
	fi

	use debug && append-cppflags "-DDEBUG"

	# we cannot use use_enable/use_with and have to manually construct the
	# socket directory argument, since --enable-socket-dir disables it, and
	# --without-socket-dir ends up configuring "no" as path. =:(
	if use multiuser; then
		local socketdir="--with-socket-dir="${EPREFIX}/run/${PN}""
	else
		local socketdir="--disable-socket-dir"
	fi

	local myeconfargs=(
		--with-system_screenrc="${EPREFIX}/etc/screenrc"
		--with-pty-mode=0620
		--with-pty-group=5
		--enable-telnet
		${socketdir}
		$(use_enable pam)
		$(use_enable utempter utmp)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	LC_ALL=POSIX emake comm.h term.h

	emake -C doc screen.info
	default
}

src_install() {
	local DOCS=(
		README ChangeLog INSTALL TODO NEWS*
		doc/{FAQ,README.DOTSCREEN,fdpat.ps,window_to_display.ps}
	)

	emake DESTDIR="${D}" SCREEN="${P}" install

	if use multiuser || use prefix ; then
		fperms 4755 /usr/bin/${P}
		local tmpfiles_perms="0755"
		local tmpfiles_group="root"
		newtmpfiles - screen.conf <<<"d /run/screen ${tmpfiles_perms} root ${tmpfiles_group}"
	else
		# undo suid bit after default installation
		fperms -s /usr/bin/${P}
	fi

	insinto /usr/share/${PN}
	doins terminfo/{screencap,screeninfo.src}

	insinto /etc
	doins "${FILESDIR}"/screenrc

	if use pam; then
		pamd_mimic_system screen auth
	fi

	dodoc "${DOCS[@]}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Some dangerous key bindings have been removed or changed to more safe values."
		elog "We enable some xterm hacks in our default screenrc, which might break some"
		elog "applications. Please check /etc/screenrc for information on these changes."
	fi

	if use multiuser; then
		tmpfiles_process screen.conf
		einfo "Note that enabling multiuser mode changes the screen socket location to ${EROOT}/run/${PN}."
	fi
}
