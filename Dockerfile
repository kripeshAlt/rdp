# Use Ubuntu as the base image
FROM ubuntu:20.04

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    x11vnc \
    xvfb \
    supervisor \
    net-tools \
    noVNC websockify \
    firefox \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -o Dpkg::Options::="--force-confold" install -y \
    xfce4 xfce4-goodies \
    x11vnc \
    xvfb \
    supervisor \
    net-tools \
    noVNC websockify \
    firefox


# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
    && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Add a user for the VNC server
RUN useradd -m vncuser

# Set environment variables
ENV USER=vncuser \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6080 \
    RESOLUTION=1024x768

# Expose the ports for VNC and noVNC
EXPOSE 5901 6080

# Copy supervisor configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Start the services
CMD ["/usr/bin/supervisord"]
