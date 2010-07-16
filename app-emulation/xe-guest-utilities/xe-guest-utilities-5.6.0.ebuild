# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Citrix XenServer daemon and tools"
HOMEPAGE="http://www.xensource.com/"

MY_PV="${PV/_p*}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

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
	elif use x86; then
		export SRC_URI="file:///mnt/cdrom/Linux/xe-guest-utilities_5.6.0-578_i386.deb"
	elif use amd64 ; then
		export SRC_URI="file:///mnt/cdrom/Linux/xe-guest-utilities_5.6.0-578_amd64.deb"
	else
		die "Unsupported architecture!"
	fi
	if [ ! -f ${SRC_URI} ]; then
		die "Please mount the 5.6.0 xentools cd"
	fi
}

src_prepare() {
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
        cd "${S}"
#        epatch "${FILESDIR}/${MY_P}-gentoo.patch"
}

src_compile() {
}

src_install() {
	insinto /usr
	dobin "${S}"/usr/bin/xenstore*

	dosbin "${S}"/xe-daemon
	dosbin "${S}"/xe-linux-distribution
	dosbin "${S}"/xe-update-guest-attrs

	newinitd "${S}"/gentoo/xe-daemon.init xe-daemon

#	mkdir -p "${D}"/etc/udev/rules.d
#	mv -f "${S}"/xen-vbd-cdrom.rules "${D}"/etc/udev/rules.d/z10-xen-vbd-cdrom.rules
#	mv -f "${S}"/xen-vcpu-hotplug.rules "${D}"/etc/udev/rules.d/z10-xen-vcpu-hotplug.rules

	dodoc "${S}"/COPYING
	dodoc "${S}"/COPYING.LGPL
}
