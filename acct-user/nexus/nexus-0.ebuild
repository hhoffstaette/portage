# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( "nexus" )
ACCT_USER_HOME="/var/lib/nexus"
ACCT_USER_SHELL="/bin/sh"

acct-user_add_deps
