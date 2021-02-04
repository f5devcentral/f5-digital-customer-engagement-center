# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.155.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"

FROM ubuntu:${VARIANT}

ENV USERNAME="codespace" \
    USER_UID=1000 \
    USER_GID=$USER_UID \
    SHELL="/bin/bash" \
    GOROOT="/usr/local/go" \
    GOPATH="/go" \
    GOVERSION="1.15.6" \
    PRECOMMITVERSION="latest" \
    TERRAFORMVERSION="0.14.0" \
    TERRAFORMDOCSVERSION="0.9.1" \
    ANSIBLEVERSION="2.10.5"

COPY scripts/* /tmp/scripts/

# base
RUN set -ex \
&& apt update && export DEBIAN_FRONTEND=noninteractive \
&& apt -y install --no-install-recommends \
sudo \
git \
zsh
# user
RUN set -ex \
 && bash /tmp/scripts/create-user.sh ${USERNAME} ${USER_UID}  \
 && bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}"
# common packages
RUN bash /tmp/scripts/common-debian.sh "true" "${USERNAME}" "${USER_UID}" "${USER_GID}" "false" "true"
#python/pip
RUN set -ex \
    && apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends \
    dnsutils \
    python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# dev
RUN set -ex \
  && bash /tmp/scripts/terraform-docs-debain.sh "${TERRAFORMDOCSVERSION}" \
  && bash /tmp/scripts/pre-commit-debian.sh "${PRECOMMITVERSION}" \
  && bash /tmp/scripts/go-debian.sh "${GOVERSION}" "${GOROOT}" "${GOPATH}" "${USERNAME}" "true" "false"
# tools
RUN set -ex \
    # && bash /tmp/scripts/sshd-debian.sh \
    && bash /tmp/scripts/azcli-debian.sh \
    && bash /tmp/scripts/gcloud-debian.sh \
    && bash /tmp/scripts/awscli-debian.sh \
    && bash /tmp/scripts/awsiam-debian.sh "${USERNAME}"
# docker
RUN set -ex \
  && bash /tmp/scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "true"
# kubectl helm
RUN set -ex \
  && bash /tmp/scripts/kubectl-helm-debian.sh
# terraform
RUN set -ex \
  && terraformVersion="${TERRAFORMVERSION}" \
  && wget https://releases.hashicorp.com/terraform/$terraformVersion/terraform_"$terraformVersion"_linux_amd64.zip \
  && unzip -o ./terraform_"$terraformVersion"_linux_amd64.zip -d /usr/local/bin/ \
  && rm ./terraform_"$terraformVersion"_linux_amd64.zip
# ansible
RUN set -ex \
  && pip3 install --upgrade pip \
  && pip3 install "ansible==${ANSIBLEVERSION}" \
  && pip3 install jinja2 \
  && pip3 install requests \
  && pip3 install google-auth
# ansible roles
RUN set -ex \
  && ansible-galaxy install nginxinc.nginx \
  && ansible-galaxy install f5devcentral.atc_deploy

# Clean up
RUN set -ex \
&& apt autoremove -y && apt clean -y && rm -rf /tmp/scripts

#change user
USER ${USERNAME}
