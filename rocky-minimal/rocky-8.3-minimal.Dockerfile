# Rocky 8.3 Minimal - Built from rocky-8.3-stable base
# This ensures VERSION_ID="8.3" is preserved
FROM rocky-8.3-stable

# Remove unnecessary packages to create minimal-like image
RUN dnf remove -y \
    vim \
    vim-enhanced \
    vim-common \
    vim-filesystem \
    nano \
    gpm-libs \
    groff-base \
    ncurses \
    perl-* \
    python3-pip \
    python3-setuptools || true && \
  dnf autoremove -y && \
  dnf clean all && \
  rm -rf /var/cache/dnf/* /var/log/* /tmp/* /var/tmp/*

# Install minimal required packages
RUN dnf install -y --releasever=8.3 --disablerepo='*' --setopt=reposdir=/dev/null \
    --setopt=timeout=120 --setopt=retries=5 \
    --repofrompath=baseos,http://dl.rockylinux.org/vault/rocky/8.3/BaseOS/x86_64/os/ \
    --repofrompath=appstream,http://dl.rockylinux.org/vault/rocky/8.3/AppStream/x86_64/os/ \
    --setopt=baseos.gpgcheck=1 --setopt=baseos.gpgkey=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial \
    --setopt=appstream.gpgcheck=1 --setopt=appstream.gpgkey=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial \
    vim-minimal && \
  dnf clean all && \
  rm -rf /var/cache/dnf/*

EXPOSE 8080 8888

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
