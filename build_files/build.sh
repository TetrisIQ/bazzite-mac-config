#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y pipx 

# install themes and icons
/ctx/theme/theme.sh

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Create a default user for VM logins
# NOTE: This sets a password in the image. Use only for VM testing.
if [[ "${USER:-}" == "alex" ]]; then
	if ! id -u bazzite >/dev/null 2>&1; then
		useradd -m -G wheel -s /bin/bash bazzite
	fi
	echo "bazzite:bazzite" | chpasswd
fi

#### Example for enabling a System Unit File

systemctl enable podman.socket
