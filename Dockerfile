FROM alpine:3.10

ENV KUBE_VERSION v1.14.6
ENV HELM_VERSION v2.14.3

RUN apk --update --no-cache add \
    bash \
    ca-certificates \
    curl \
    jq \
    git \
    openssh-client \
    python2 \
    tar \
    wget \
    alpine-sdk

RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Install kubectl
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install envsubst
ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

WORKDIR /work

CMD ["helm", "version"]