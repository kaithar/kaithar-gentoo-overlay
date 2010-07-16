# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Citrix XenServer daemon and tools"
HOMEPAGE="http://www.xensource.com/"
SRC_URI="
   x86? ( null://mnt/cdrom/Linux/xe-guest-utilities_5.6.0-578_i386.deb )
   amd64? ( null://mnt/cdrom/Linux/xe-guest-utilities_5.6.0-578_amd64.deb )"

RESTRICT="fetch"

MY_PV="${PV/_p*}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/python
	sys-libs/zlib"

RDEPEND="${CDEPEND}
	|| ( sys-fs/udev sys-apps/hotplug )"

pkg_setup() {
	if use x86 && use amd64; then
		die "Confusion! Both x86 and amd64 are set in your use flags!"
	fi
}


src_unpack() {
	unpack ${A}
	unpack "./data.tar.gz"
	cd "${S}"
	epatch "${FILESDIR}/${MY_P}-gentoo.patch"
}

src_install() {
	insinto /usr
	dobin "${S}"/usr/bin/xenstore*

	dosbin "${S}"/usr/sbin/xe-daemon
	dosbin "${S}"/usr/sbin/xe-linux-distribution
	dosbin "${S}"/usr/sbin/xe-update-guest-attrs

	newinitd "${S}"/gentoo/xe-daemon.init xe-daemon

#	mkdir -p "${D}"/etc/udev/rules.d
#	mv -f "${S}"/xen-vcpu-hotplug.rules "${D}"/etc/udev/rules.d/z10-xen-vcpu-hotplug.rules
#	This should probably be installed via newins, but I don't want it
#	regardless; Changing vcpus on a running VM is probably a recipe for madness.

	dodoc "${S}"/usr/share/doc/xe-guest-utilities/COPYING
	dodoc "${S}"/usr/share/doc/xe-guest-utilities/COPYING.LGPL
	dodoc "${S}"/usr/share/doc/xe-guest-utilities/copyright
}
