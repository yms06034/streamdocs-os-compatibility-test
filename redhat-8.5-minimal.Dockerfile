FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

RUN microdnf install -y \
    procps-ng \
    wget \
    curl \
    vim-minimal \
    tar \
    findutils && \
  microdnf clean all

EXPOSE 8088

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
