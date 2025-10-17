FROM rockylinux:8

RUN dnf -y install dnf ca-certificates dnf-plugins-core && update-ca-trust && dnf clean all

ENV RL_VER=8.3 \
    RL_GPG=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial \
    RL_BASEOS=http://dl.rockylinux.org/vault/rocky/8.3/BaseOS/x86_64/os/ \
    RL_APPSTR=http://dl.rockylinux.org/vault/rocky/8.3/AppStream/x86_64/os/ \
    RL_POWERTOOLS=http://dl.rockylinux.org/vault/rocky/8.3/PowerTools/x86_64/os/ \
    RL_EXTRAS=http://dl.rockylinux.org/vault/rocky/8.3/extras/x86_64/os/

RUN set -eux; \
  dnf -y --releasever=${RL_VER} --disablerepo='*' --setopt=reposdir=/dev/null \
    --setopt=timeout=120 --setopt=retries=5 --setopt=fastestmirror=0 \
    --repofrompath=baseos,${RL_BASEOS} \
    --repofrompath=appstream,${RL_APPSTR} \
    --repofrompath=powertools,${RL_POWERTOOLS} \
    --repofrompath=extras,${RL_EXTRAS} \
    --setopt=baseos.gpgcheck=1 --setopt=baseos.gpgkey=${RL_GPG} \
    --setopt=appstream.gpgcheck=1 --setopt=appstream.gpgkey=${RL_GPG} \
    --setopt=powertools.gpgcheck=1 --setopt=powertools.gpgkey=${RL_GPG} \
    --setopt=extras.gpgcheck=1 --setopt=extras.gpgkey=${RL_GPG} \
    makecache && \
  dnf -y --releasever=${RL_VER} --disablerepo='*' --setopt=reposdir=/dev/null \
    --setopt=timeout=120 --setopt=retries=5 --setopt=fastestmirror=0 \
    --repofrompath=baseos,${RL_BASEOS} \
    --repofrompath=appstream,${RL_APPSTR} \
    --repofrompath=powertools,${RL_POWERTOOLS} \
    --repofrompath=extras,${RL_EXTRAS} \
    distro-sync && \
  dnf -y --releasever=${RL_VER} --disablerepo='*' --setopt=reposdir=/dev/null \
    --setopt=timeout=120 --setopt=retries=5 --setopt=fastestmirror=0 \
    --repofrompath=baseos,${RL_BASEOS} \
    --repofrompath=appstream,${RL_APPSTR} \
    --repofrompath=powertools,${RL_POWERTOOLS} \
    --repofrompath=extras,${RL_EXTRAS} \
    install -y --allowerasing coreutils-single procps-ng wget curl vim-minimal tar unzip findutils && \
  dnf clean all

RUN dnf remove -y \
    java-1.8.0-openjdk \
    java-1.8.0-openjdk-headless \
    dejavu-fonts-common \
    dejavu-sans-fonts \
    fontconfig \
    fontpackages-filesystem \
    gtk2 \
    gtk-update-icon-cache \
    cairo \
    cups-libs \
    alsa-lib \
    avahi-libs \
    dbus \
    dbus-daemon \
    dbus-tools \
    dbus-glib \
    dbus-libs \
    dbus-common \
    libX11 \
    libX11-common \
    xorg-x11-font-utils \
    xorg-x11-fonts-Type1 \
    xkeyboard-config \
    javapackages-filesystem \
    copy-jdk-configs \
    tzdata-java \
    bind-export-libs \
    dhcp-client \
    dhcp-common \
    dhcp-libs \
    dracut \
    dracut-network \
    dracut-squash \
    firewalld \
    firewalld-filesystem \
    kmod \
    kpartx \
    device-mapper-multipath \
    gettext \
    gettext-libs \
    grub2-tools \
    grub2-tools-minimal \
    grub2-common \
    grubby \
    os-prober \
    kbd \
    kbd-misc \
    kbd-legacy \
    kexec-tools \
    openssh \
    openssh-clients \
    openssh-server \
    parted \
    pigz \
    plymouth \
    python3-firewall \
    python3-unbound \
    python3-dnf-plugins-core \
    python3-systemd \
    python3-dateutil \
    python3-dbus \
    python3-six \
    dnf-plugins-core \
    teamd \
    trousers \
    trousers-lib \
    wpa_supplicant \
    NetworkManager \
    NetworkManager-libnm \
    unbound-libs \
    libevent \
    iptables-libs \
    iputils \
    iproute \
    systemd-udev \
    openssl-pkcs11 \
    libsecret \
    pinentry \
    memstrack \
    crypto-policies-scripts \
    shared-mime-info \
    rpm-plugin-systemd-inhibit \
    platform-python-pip \
    diffutils \
    file \
    file-libs \
    hardlink \
    cpio \
    xz \
    gawk \
    info \
    libpcap || true && \
  dnf autoremove -y && \
  dnf clean all && \
  rm -rf /var/cache/dnf/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
