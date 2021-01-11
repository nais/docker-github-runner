FROM debian:buster-slim

ARG GITHUB_RUNNER_VERSION="2.273.5"
ARG HELM_VERSION="v3.3.0"
ARG KUBECTL_VERSION="1.18.6"
ARG YQ_VERSION="3.3.2"
ARG NAIS_BUILDER_IMAGES_COMMIT="b04ba01efaaf42b38e3abcc0237630c3cc42819e"

ENV GITHUB_REPO "navikt/nais-platform-apps"
ENV GITHUB_PAT ""
ENV RUNNER_TOKEN ""
ENV NAIS_CLUSTER_NAME ""
ENV NAIS_NAMESPACE ""
ENV SLACK_WEBHOOK ""

USER root

RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        jq \
        sudo \
        locales \
        iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && useradd -m -d /opt/runner runner

RUN curl -Ls https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | \
    tar -xz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/bin

RUN curl -Ls https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

RUN curl -Ls https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN curl -Ls https://raw.githubusercontent.com/nais/builder_images/${NAIS_BUILDER_IMAGES_COMMIT}/naiscaper/naiscaper -o /usr/bin/naiscaper && \
    chmod +x /usr/bin/naiscaper

RUN curl -Ls https://raw.githubusercontent.com/nais/builder_images/${NAIS_BUILDER_IMAGES_COMMIT}/bashscaper/bashscaper -o /usr/bin/bashscaper && \
    chmod +x /usr/bin/bashscaper

RUN curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | \
    sudo -u runner tar -xz -C /opt/runner --no-same-owner && \
    /opt/runner/bin/installdependencies.sh

COPY entrypoint.sh /opt/entrypoint.sh
COPY unregister-runner.sh /opt/unregister-runner.sh

USER runner
WORKDIR /opt/runner

ENTRYPOINT ["/opt/entrypoint.sh"]
