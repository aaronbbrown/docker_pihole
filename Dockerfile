FROM debian:jessie

ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.7.5/bin/linux/amd64/kubectl
ARG KUBECTL_SHA=0392ed74bc29137b2a7db7aca9a0a0c1bc85c4cd55b6a42ea556e1a7c485f745
ARG PIHOLE_URL=https://github.com/pi-hole/pi-hole/archive/v3.1.4.tar.gz

RUN apt-get update && \
    apt-get -y install \
    curl \
    dnsutils \
    git \
    bc \
    dnsutils \
    lsof \
    netcat \
    unzip \
    wget \
    net-tools

RUN curl -fsSL "$KUBECTL_URL" -o /usr/bin/kubectl \
  && echo "$KUBECTL_SHA /usr/bin/kubectl" | sha256sum -c - \
  && chmod +x /usr/bin/kubectl \
  && kubectl version --client

WORKDIR /usr/src/pi-hole-3.1.4

RUN curl -Lso /usr/src/pihole.tgz "$PIHOLE_URL" && \
    mkdir -p /etc/pihole && \
    tar -xzf /usr/src/pihole.tgz -C /usr/src && \
    mkdir -p /etc/.pihole && \
    mkdir -p /opt/pihole && \
    cp -v adlists.default /etc/.pihole/adlists.default && \
    cp -v gravity.sh /opt/pihole && \
    cp -v pihole /usr/local/bin/pihole  && \
    cp -v advanced/Scripts/* /opt/pihole && \
    chmod +x /opt/pihole/*.sh && \
    touch /etc/pihole/setupVars.conf

RUN rm -rf /usr/src/pi-hole-3.1.4 /usr/src/pihole.tgz

CMD ["bash", "-c", "touch /etc/pihole/setupVars.conf && /opt/pihole/gravity.sh"]
