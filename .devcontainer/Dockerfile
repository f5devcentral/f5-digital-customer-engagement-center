# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.154.0/containers/codespaces-linux/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/universal:1-focal

# ** [Optional] Uncomment this section to install additional packages. **
USER root

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    jq \
    less \
    curl \
    dnsutils
# tools
RUN set -ex \
  && terraformDocsVersion="0.9.1" \
  && curl -sLo /usr/local/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v${terraformDocsVersion}/terraform-docs-v${terraformDocsVersion}-linux-amd64 \
  && chmod 0755 /usr/local/bin/terraform-docs \
  && echo "---installing pre-commit---" \
  && pip3 install pre-commit \
  && goLangVersion="1.15.6" \
  && wget https://golang.org/dl/go${goLangVersion}.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go${goLangVersion}.linux-amd64.tar.gz \
  && rm go${goLangVersion}.linux-amd64.tar.gz
# terraform
RUN set -ex \
  && terraformVersion="0.14.0" \
  && wget https://releases.hashicorp.com/terraform/$terraformVersion/terraform_"$terraformVersion"_linux_amd64.zip \
  && unzip -o ./terraform_"$terraformVersion"_linux_amd64.zip -d /usr/local/bin/ \
  && rm ./terraform_"$terraformVersion"_linux_amd64.zip
# ansible
RUN set -ex \
  && pip3 install --upgrade pip \
  && pip3 install ansible \
  && pip3 install jinja2 \
  && pip3 install requests \
  && pip3 install google-auth
# ansible roles
RUN set -ex \
  && ansible-galaxy install nginxinc.nginx \
  && ansible-galaxy install f5devcentral.atc_deploy

# change user
USER codespace
