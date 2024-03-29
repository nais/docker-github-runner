FROM docker.io/curlimages/curl:latest as linkerd
ARG LINKERD_AWAIT_VERSION=v0.2.4
RUN curl -sSLo /tmp/linkerd-await https://github.com/linkerd/linkerd-await/releases/download/release%2F${LINKERD_AWAIT_VERSION}/linkerd-await-${LINKERD_AWAIT_VERSION}-amd64 && \
    chmod 755 /tmp/linkerd-await

FROM debian:buster-slim

ARG GITHUB_RUNNER_VERSION="2.283.1"
ARG HELM_VERSION="v3.9.4"
ARG KUBECTL_VERSION="1.23.12"
ARG YQ_VERSION="v4.13.2"

ENV GITHUB_REPO ""
ENV GITHUB_PAT ""
ENV RUNNER_TOKEN ""
ENV RUNNER_LABELS "docker-github-runner"
ENV LINKERD_AWAIT_DISABLED "set LINKERD_AWAIT_DISABLED empty if running with Linkerd-proxy"

USER root

RUN apt-get update \
    && apt-get install -y \
        wget \
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

COPY --from=linkerd /tmp/linkerd-await /linkerd-await

RUN curl -Ls https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | \
    tar -xz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/bin

RUN curl -Ls https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

RUN curl -Ls https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | \
    sudo -u runner tar -xz -C /opt/runner --no-same-owner && \
    /opt/runner/bin/installdependencies.sh

COPY start-runner.sh /opt/start-runner.sh
COPY unregister-runner.sh /opt/unregister-runner.sh

USER runner
WORKDIR /opt/runner

ENTRYPOINT ["/linkerd-await", "--"]
CMD ["/opt/start-runner.sh"]
