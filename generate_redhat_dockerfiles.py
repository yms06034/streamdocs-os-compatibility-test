import os

STABLE_VERSIONS = [
    "9.5", "9.3", "9.2", "9.1",
    "8.8", "8.7", "8.6", "8.5", "8.4", "8.3", "8.2", "8.1"
]

MINIMAL_VERSIONS = [
    "9.6", "9.4", "9.3", "9.1", "9.0",
    "8.9", "8.8", "8.7", "8.6", "8.4", "8.3", "8.2", "8.1", "8.0"
]

def get_major_version(version):
    return version.split('.')[0]

def generate_stable_dockerfile(version):
    major = get_major_version(version)

    return f"""FROM registry.redhat.io/ubi{major}/ubi:{version}

RUN dnf install -y subscription-manager && \\
  dnf clean all

ARG RHEL_USERNAME
ARG RHEL_PASSWORD

RUN subscription-manager register --username=${{RHEL_USERNAME}} --password=${{RHEL_PASSWORD}} --auto-attach || true

RUN subscription-manager repos --enable=rhel-{major}-for-x86_64-baseos-rpms \\
    --enable=rhel-{major}-for-x86_64-appstream-rpms || true

RUN dnf install -y --releasever={version} \\
    coreutils \\
    procps-ng \\
    wget \\
    curl \\
    vim-minimal \\
    tar \\
    unzip \\
    findutils \\
    which \\
    net-tools \\
    iproute \\
    xorg-x11-server-Xvfb && \\
  dnf clean all

RUN subscription-manager unregister || true

RUN dnf remove -y subscription-manager || true && \\
  dnf clean all && \\
  rm -rf /var/cache/dnf/* /var/cache/yum/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && \\
  rpm -q glibc && \\
  echo "=== Total packages ===" && \\
  rpm -qa | wc -l && \\
  echo "=== Xvfb check ===" && \\
  rpm -q xorg-x11-server-Xvfb

CMD ["/bin/bash"]
"""

def generate_minimal_dockerfile(version):
    major = get_major_version(version)

    return f"""FROM registry.redhat.io/ubi{major}/ubi-minimal:{version}

RUN microdnf install -y dnf subscription-manager && \\
  microdnf clean all

ARG RHEL_USERNAME
ARG RHEL_PASSWORD

RUN subscription-manager register --username=${{RHEL_USERNAME}} --password=${{RHEL_PASSWORD}} --auto-attach || true

RUN subscription-manager repos --enable=rhel-{major}-for-x86_64-baseos-rpms \\
    --enable=rhel-{major}-for-x86_64-appstream-rpms || true

RUN microdnf install -y --releasever={version} \\
    coreutils-single \\
    procps-ng \\
    wget \\
    curl \\
    vim-minimal \\
    tar \\
    unzip \\
    findutils \\
    xorg-x11-server-Xvfb && \\
  microdnf clean all

RUN subscription-manager unregister || true

RUN microdnf remove -y subscription-manager dnf || true && \\
  microdnf clean all && \\
  rm -rf /var/cache/dnf/* /var/cache/yum/* /var/log/* /tmp/* /var/tmp/*

EXPOSE 8088

RUN cat /etc/os-release && \\
  rpm -q glibc && \\
  echo "=== Total packages ===" && \\
  rpm -qa | wc -l && \\
  echo "=== Xvfb check ===" && \\
  rpm -q xorg-x11-server-Xvfb

CMD ["/bin/bash"]
"""

def main():
    stable_dir = "redhat-stable"
    minimal_dir = "redhat-minimal"

    os.makedirs(stable_dir, exist_ok=True)
    os.makedirs(minimal_dir, exist_ok=True)

    print("Generating stable Dockerfiles...")
    for version in STABLE_VERSIONS:
        filename = f"redhat-{version}-stable.Dockerfile"
        filepath = os.path.join(stable_dir, filename)

        content = generate_stable_dockerfile(version)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"  Created {filepath}")
  
    print("\\nGenerating minimal Dockerfiles...")
    for version in MINIMAL_VERSIONS:
        filename = f"redhat-{version}-minimal.Dockerfile"
        filepath = os.path.join(minimal_dir, filename)

        content = generate_minimal_dockerfile(version)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"  Created {filepath}")

    print(f"\\nGenerated {len(STABLE_VERSIONS)} stable + {len(MINIMAL_VERSIONS)} minimal = {len(STABLE_VERSIONS) + len(MINIMAL_VERSIONS)} Dockerfiles")

if __name__ == "__main__":
    main()
