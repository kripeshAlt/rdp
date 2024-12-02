# Base image: Ubuntu 22.04
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    xfce4 \
    xfce4-goodies \
    novnc \
    websockify \
    x11vnc \
    xserver-xorg-core \
    supervisor \
    curl \
    wget \
    dbus-x11 \
    firefox-esr \
    --no-install-recommends

# Create a non-root user
RUN useradd -m -s /bin/bash renderuser && echo "renderuser:renderpass" | chpasswd && adduser renderuser sudo

# Install noVNC
RUN mkdir -p /opt/novnc/utils/websockify && \
    curl -L https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz | tar xz --strip-components=1 -C /opt/novnc && \
    curl -L https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.tar.gz | tar xz --strip-components=1 -C /opt/novnc/utils/websockify && \
    chmod +x /opt/novnc/utils/*.sh

# Configure X11VNC
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd renderpass ~/.vnc/passwd

# Configure Supervisor
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Expose necessary ports
EXPOSE 8080 5901

# Start the Supervisor service
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
