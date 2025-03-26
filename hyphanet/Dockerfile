FROM jdk9:alpine AS base
RUN apk add --no-cache openssh-server


FROM base AS install
ARG user=hyphanet
ARG home=/opt/hyphanet
WORKDIR $home

COPY remote_authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && \
    sed -i 's/^AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config && \
    addgroup -S $user && \
    adduser -S -h $home -G $user $user && \
    echo $user ALL=\(ALL\) NOPASSWD: ALL >> /etc/sudoers

USER $user

COPY install/* ./
RUN sudo chown -R $user:$user $home && \
    sudo chmod ug+x setup.sh && \
    ./setup.sh

COPY files/hyphanet.sh ./
EXPOSE 22

ENV OUTPUT_BANDWIDTH=100000000 \
    INPUT_BANDWIDTH=100000000 \
    STORE_SIZE=100000000
VOLUME /opt/hyphanet/data

ENTRYPOINT ["./hyphanet.sh"]
