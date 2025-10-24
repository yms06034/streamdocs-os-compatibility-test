FROM registry.redhat.io/ubi8/ubi-minimal:8.5

RUN microdnf install -y dnf subscription-manager && \
  microdnf clean all

ARG RHEL_USERNAME
ARG RHEL_PASSWORD

RUN subscription-manager register --username=${RHEL_USERNAME} --password=${RHEL_PASSWORD} --auto-attach || true

RUN subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms \
    --enable=rhel-8-for-x86_64-appstream-rpms || true

RUN microdnf install -y --releasever=8.5 \
    coreutils-single \
    procps-ng \
    wget \
    curl \
    vim-minimal \
    tar \
    unzip \
    findutils \
    xorg-x11-server-Xvfb && \
  microdnf clean all

RUN subscription-manager unregister || true

RUN microdnf remove -y subscription-manager dnf || true && \
  microdnf clean all && \
  rm -rf /var/cache/dnf/* /var/cache/yum/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && \
  rpm -q glibc && \
  echo "=== Total packages ===" && \
  rpm -qa | wc -l && \
  echo "=== Xvfb check ===" && \
  rpm -q xorg-x11-server-Xvfb
