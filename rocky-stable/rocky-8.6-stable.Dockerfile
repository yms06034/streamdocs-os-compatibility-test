FROM rockylinux:8.6

# 필요한 패키지 설치
RUN dnf install -y --allowerasing \
    procps-ng \
    iproute \
    coreutils \
    findutils \
    which \
    unzip \
    wget \
    curl \
    net-tools \
    vim \
    nano \
    tar \
    gzip && \
  dnf clean all && \
  rm -rf /var/cache/dnf/*

EXPOSE 8088

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
