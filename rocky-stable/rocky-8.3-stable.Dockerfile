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
    install -y --allowerasing procps-ng iproute coreutils findutils which unzip wget curl \
    net-tools vim nano tar gzip && \
  dnf clean all

EXPOSE 8080 8888

RUN cat /etc/os-release && rpm -q glibc
CMD ["/bin/bash"]
