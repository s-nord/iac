FROM fedora:36

RUN dnf -y install ca-certificates \
  curl git wget \
  python pip \
  openssh-clients ansible
COPY kubernetes.repo /etc/yum.repos.d/kubernetes.repo

RUN dnf -y install kubectl helm
RUN dnf -y install https://github.com/mozilla/sops/releases/download/v3.7.3/sops-3.7.3-1.x86_64.rpm
RUN helm plugin install https://github.com/futuresimple/helm-secrets
