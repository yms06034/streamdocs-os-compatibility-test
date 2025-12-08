FROM registry.redhat.io/ubi8/ubi-minimal:8.7

RUN microdnf install -y subscription-manager && \
  microdnf clean all

ARG RHEL_USERNAME
ARG RHEL_PASSWORD

RUN subscription-manager register --username=${RHEL_USERNAME} --password=${RHEL_PASSWORD} --auto-attach

RUN subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms \
    --enable=rhel-8-for-x86_64-appstream-rpms || true

RUN microdnf install -y --releasever=8.7 \
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
  microdnf clean all

RUN subscription-manager unregister || true

RUN microdnf remove -y subscription-manager || true && \
  microdnf clean all && \
  rm -rf /var/cache/yum/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && \
  rpm -q glibc && \
  echo "=== Total packages ===" && \
  rpm -qa | wc -l && \
  echo "=== Xvfb check ===" && \
  (rpm -q xorg-x11-server-Xvfb || echo "Xvfb not installed")

CMD ["/bin/bash"]
