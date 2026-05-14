FROM ubuntu:24.04

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

# Instalar systemd, dbus y herramientas esenciales
RUN apt update && apt install -y \
    systemd \
    systemd-sysv \
    dbus \
    sudo \
    curl \
    wget \
    nano \
    vim \
    iproute2 \
    net-tools \
    iputils-ping \
    bash-completion \
    ca-certificates \
    openssh-server \
    cron \
    rsyslog \
    locales \
    tzdata && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Configurar locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Crear directorios necesarios
RUN mkdir -p /run/systemd && \
    mkdir -p /run/dbus && \
    mkdir -p /var/run/dbus

# Habilitar servicios básicos
RUN systemctl enable dbus && \
    systemctl enable ssh && \
    systemctl enable cron && \
    systemctl enable rsyslog

# Detener servicios innecesarios para Docker
RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    systemd-remount-fs.service \
    getty.target \
    console-getty.service

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]

CMD ["/sbin/init"]
