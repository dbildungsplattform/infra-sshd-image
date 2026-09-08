FROM ubuntu:24.04 AS release

ARG BUILD_BRANCH
ARG BUILD_HASH

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

LABEL build.stage="release"
LABEL build.branch="${BUILD_BRANCH}"
LABEL build.hash="${BUILD_HASH}"

# Install sshd
RUN set -x \
    && apt-get -y update --no-install-recommends \
    && apt-get -y upgrade \
    && apt-get -y install \
        openssh-server\
    && rm -rf /var/lib/apt/lists/*\
    && rm /etc/ssh/ssh_host_*

# Dir /var/run/sshd is required by daemon
RUN mkdir /var/run/sshd

RUN mkdir /entrypoint
COPY docker-entrypoint.sh /entrypoint/docker-entrypoint.sh
RUN chmod +x /entrypoint/docker-entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint/docker-entrypoint.sh"]
