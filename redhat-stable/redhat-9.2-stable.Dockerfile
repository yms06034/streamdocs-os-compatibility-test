FROM registry.redhat.io/ubi9/ubi:9.2

RUN dnf install -y subscription-manager && \
  dnf clean all

ARG RHEL_USERNAME
ARG RHEL_PASSWORD

RUN subscription-manager register --username=${RHEL_USERNAME} --password=${RHEL_PASSWORD} --auto-attach

RUN subscription-manager repos --enable=rhel-9-for-x86_64-baseos-rpms \
    --enable=rhel-9-for-x86_64-appstream-rpms || true

RUN dnf install -y --allowerasing --releasever=9.2 \
    procps-ng \
    wget \
    vim-minimal \
    tar \
    unzip \
    findutils \
    which \
    net-tools \
    iproute \
    xorg-x11-server-Xvfb && \
  dnf clean all

RUN subscription-manager unregister || true

RUN dnf remove -y subscription-manager || true && \
  dnf clean all && \
  rm -rf /var/cache/dnf/* /var/cache/yum/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && \
  rpm -q glibc && \
  echo "=== Total packages ===" && \
  rpm -qa | wc -l && \
  echo "=== Xvfb check ===" && \
  (rpm -q xorg-x11-server-Xvfb || echo "Xvfb not installed")

CMD ["/bin/bash"]
