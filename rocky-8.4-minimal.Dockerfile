FROM quay.io/rockylinux/rockylinux:8.4

RUN set -eux; \
  rm -f /etc/yum.repos.d/*.repo && \
  echo '[baseos]' > /etc/yum.repos.d/rocky.repo && \
  echo 'name=Rocky Linux 8.4 - BaseOS' >> /etc/yum.repos.d/rocky.repo && \
  echo 'baseurl=http://dl.rockylinux.org/vault/rocky/8.4/BaseOS/$basearch/os/' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgcheck=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'enabled=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgkey=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial' >> /etc/yum.repos.d/rocky.repo && \
  echo '' >> /etc/yum.repos.d/rocky.repo && \
  echo '[appstream]' >> /etc/yum.repos.d/rocky.repo && \
  echo 'name=Rocky Linux 8.4 - AppStream' >> /etc/yum.repos.d/rocky.repo && \
  echo 'baseurl=http://dl.rockylinux.org/vault/rocky/8.4/AppStream/$basearch/os/' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgcheck=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'enabled=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgkey=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial' >> /etc/yum.repos.d/rocky.repo

RUN dnf install -y --releasever=8.4 \
    coreutils-single \
    procps-ng \
    wget \
    curl \
    vim-minimal \
    tar \
    unzip \
    findutils && \
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
    libX11 \
    libX11-common \
    xorg-x11-font-utils \
    xorg-x11-fonts-Type1 \
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
    grub2-tools \
    grub2-tools-minimal \
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
    teamd \
    trousers \
    wpa_supplicant \
    NetworkManager \
    NetworkManager-libnm || true && \
  dnf autoremove -y && \
  dnf clean all && \
  rm -rf /var/cache/dnf/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
