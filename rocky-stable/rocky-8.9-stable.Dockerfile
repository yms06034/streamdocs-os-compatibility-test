FROM rockylinux:8.9

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

EXPOSE 8080 8888

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
