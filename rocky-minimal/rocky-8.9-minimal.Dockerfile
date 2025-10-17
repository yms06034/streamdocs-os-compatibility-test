FROM rockylinux:8.9-minimal

RUN set -eux; \
  rm -f /etc/yum.repos.d/*.repo && \
  echo '[baseos]' > /etc/yum.repos.d/rocky.repo && \
  echo 'name=Rocky Linux 8.9 - BaseOS' >> /etc/yum.repos.d/rocky.repo && \
  echo 'baseurl=http://dl.rockylinux.org/vault/rocky/8.9/BaseOS/$basearch/os/' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgcheck=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'enabled=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgkey=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial' >> /etc/yum.repos.d/rocky.repo && \
  echo '' >> /etc/yum.repos.d/rocky.repo && \
  echo '[appstream]' >> /etc/yum.repos.d/rocky.repo && \
  echo 'name=Rocky Linux 8.9 - AppStream' >> /etc/yum.repos.d/rocky.repo && \
  echo 'baseurl=http://dl.rockylinux.org/vault/rocky/8.9/AppStream/$basearch/os/' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgcheck=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'enabled=1' >> /etc/yum.repos.d/rocky.repo && \
  echo 'gpgkey=https://dl.rockylinux.org/pub/rocky/RPM-GPG-KEY-rockyofficial' >> /etc/yum.repos.d/rocky.repo

RUN microdnf install -y --releasever=8.9 \
    coreutils-single \
    procps-ng \
    wget \
    curl \
    vim-minimal \
    tar \
    unzip \
    findutils && \
  microdnf clean all

EXPOSE 8088

RUN cat /etc/os-release && rpm -q glibc && echo "=== Total packages ===" && rpm -qa | wc -l
CMD ["/bin/bash"]
