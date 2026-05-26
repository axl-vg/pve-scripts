#!/bin/bash

function create_template() {
    echo "Creating template $2 ($1)"

    qm create $1 --name $2 --ostype l26
    qm set $1 --net0 virtio,bridge=vmbr0
    qm set $1 --serial0 socket --vga serial0
    qm set $1 --memory 796 --cores 1 --cpu host
    qm set $1 --scsi0 ${storage}:0,import-from="$(pwd)/$3",discard=on
    qm set $1 --boot order=scsi0 --scsihw virtio-scsi-single
    qm set $1 --agent enabled=1,fstrim_cloned_disks=1
    qm set $1 --ide2 ${storage}:cloudinit
    qm set $1 --ipconfig0 "ip6=auto,ip=dhcp"
    # Blank password for root, no SSH key
    qm set $1 --ciuser root --cipassword ""
    qm disk resize $1 scsi0 8G
    qm template $1

    rm $3
}

export storage=bootmedia


## ============================================================
## Debian
## ============================================================

# Buster (10) - very old, kept for compatibility
wget "https://cloud.debian.org/images/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2"
create_template 900 "temp-debian-10" "debian-10-genericcloud-amd64.qcow2"

# Bullseye (11) - oldoldstable
wget "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
create_template 901 "temp-debian-11" "debian-11-genericcloud-amd64.qcow2"

# Bookworm (12) - oldstable
wget "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
create_template 902 "temp-debian-12" "debian-12-genericcloud-amd64.qcow2"

# Trixie (13) - stable
wget "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
create_template 903 "temp-debian-13" "debian-13-genericcloud-amd64.qcow2"

# Sid - unstable/rolling
wget "https://cloud.debian.org/images/cloud/sid/daily/latest/debian-sid-genericcloud-amd64-daily.qcow2"
create_template 909 "temp-debian-sid" "debian-sid-genericcloud-amd64-daily.qcow2"


## ============================================================
## Ubuntu
## ============================================================

# 20.04 LTS (Focal Fossa)
wget "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
create_template 910 "temp-ubuntu-20-04" "ubuntu-20.04-server-cloudimg-amd64.img"

# 22.04 LTS (Jammy Jellyfish)
wget "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
create_template 911 "temp-ubuntu-22-04" "ubuntu-22.04-server-cloudimg-amd64.img"

# 24.04 LTS (Noble Numbat)
wget "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
create_template 912 "temp-ubuntu-24-04" "ubuntu-24.04-server-cloudimg-amd64.img"

# 24.10 (Oracular Oriole)
wget "https://cloud-images.ubuntu.com/releases/24.10/release/ubuntu-24.10-server-cloudimg-amd64.img"
create_template 913 "temp-ubuntu-24-10" "ubuntu-24.10-server-cloudimg-amd64.img"

# 25.04 (Plucky Puffin)
wget "https://cloud-images.ubuntu.com/releases/25.04/release/ubuntu-25.04-server-cloudimg-amd64.img"
create_template 914 "temp-ubuntu-25-04" "ubuntu-25.04-server-cloudimg-amd64.img"


## ============================================================
## Fedora
## ============================================================

# Fedora 41
wget "https://mirror.accum.se/mirror/fedora/linux/releases/41/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2"
create_template 921 "temp-fedora-41" "Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2"

# Fedora 42
wget "https://mirror.accum.se/mirror/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
create_template 922 "temp-fedora-42" "Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"


## ============================================================
## Rocky Linux
## ============================================================

# Rocky 8
wget "https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2"
create_template 930 "temp-rocky-8" "Rocky-8-GenericCloud.latest.x86_64.qcow2"

# Rocky 9
wget "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
create_template 931 "temp-rocky-9" "Rocky-9-GenericCloud.latest.x86_64.qcow2"

# Rocky 10
wget "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud.latest.x86_64.qcow2"
create_template 932 "temp-rocky-10" "Rocky-10-GenericCloud.latest.x86_64.qcow2"


## ============================================================
## AlmaLinux
## ============================================================

# AlmaLinux 8
wget "https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
create_template 940 "temp-almalinux-8" "AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"

# AlmaLinux 9
wget "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
create_template 941 "temp-almalinux-9" "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"

# AlmaLinux 10
wget "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"
create_template 942 "temp-almalinux-10" "AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"


## ============================================================
## CentOS Stream
## ============================================================

# CentOS Stream 9
wget "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"
create_template 950 "temp-centos-stream-9" "CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"

# CentOS Stream 10
wget "https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2"
create_template 951 "temp-centos-stream-10" "CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2"


## ============================================================
## Oracle Linux
## ============================================================

# Oracle Linux 8 (latest u10)
wget "https://yum.oracle.com/templates/OracleLinux/OL8/u10/x86_64/OL8U10_x86_64-kvm-b237.qcow2"
create_template 960 "temp-oracle-8" "OL8U10_x86_64-kvm-b237.qcow2"

# Oracle Linux 9 (latest u5)
wget "https://yum.oracle.com/templates/OracleLinux/OL9/u5/x86_64/OL9U5_x86_64-kvm-b253.qcow2"
create_template 961 "temp-oracle-9" "OL9U5_x86_64-kvm-b253.qcow2"


## ============================================================
## openSUSE
## ============================================================

# openSUSE Leap 15.5
wget "https://download.opensuse.org/distribution/leap/15.5/appliances/openSUSE-Leap-15.5-Minimal-VM.x86_64-Cloud.qcow2"
create_template 970 "temp-opensuse-leap-15-5" "openSUSE-Leap-15.5-Minimal-VM.x86_64-Cloud.qcow2"

# openSUSE Leap 15.6
wget "https://download.opensuse.org/distribution/leap/15.6/appliances/openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud.qcow2"
create_template 971 "temp-opensuse-leap-15-6" "openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud.qcow2"

# openSUSE Leap 16.0
wget "https://download.opensuse.org/distribution/leap/16.0/appliances/Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2"
create_template 972 "temp-opensuse-leap-16-0" "Leap-16.0-Minimal-VM.x86_64-Cloud.qcow2"

# openSUSE Tumbleweed (rolling)
wget "https://download.opensuse.org/tumbleweed/appliances/openSUSE-Tumbleweed-Minimal-VM.x86_64-Cloud.qcow2"
create_template 973 "temp-opensuse-tumbleweed" "openSUSE-Tumbleweed-Minimal-VM.x86_64-Cloud.qcow2"


## ============================================================
## Alpine Linux
## ============================================================

# Alpine 3.22.0
wget "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/cloud/generic_alpine-3.22.0-x86_64-bios-cloudinit-r0.qcow2"
create_template 980 "temp-alpine-3.22" "generic_alpine-3.22.0-x86_64-bios-cloudinit-r0.qcow2"


## ============================================================
## Arch Linux
## ============================================================

# Arch Linux (rolling, cloud-init image, updated nightly)
wget "https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
create_template 990 "temp-arch-linux" "Arch-Linux-x86_64-cloudimg.qcow2"


## ============================================================
## Kali Linux
## ============================================================

# Kali Linux (rolling)
# Note: Kali's genericcloud image uses "kali" as the default user
wget "https://image-amd64.kali.org/cloud/kali-rolling/kali-linux-kali-rolling-cloud-genericcloud-amd64.qcow2"
create_template 995 "temp-kali-rolling" "kali-linux-kali-rolling-cloud-genericcloud-amd64.qcow2"


## ============================================================
## FreeBSD
## ============================================================

# FreeBSD 14.2 RELEASE
# Note: FreeBSD's CLOUDINIT image does NOT actually use cloud-init
# Default login: freebsd / freebsd (via console)
wget "https://download.freebsd.org/releases/VM-IMAGES/14.2-RELEASE/amd64/Latest/FreeBSD-14.2-RELEASE-amd64-BASIC-CLOUDINIT.ufs.qcow2.xz"
xz -d -v "FreeBSD-14.2-RELEASE-amd64-BASIC-CLOUDINIT.ufs.qcow2.xz"
create_template 999 "temp-freebsd-14.2" "FreeBSD-14.2-RELEASE-amd64-BASIC-CLOUDINIT.ufs.qcow2"
