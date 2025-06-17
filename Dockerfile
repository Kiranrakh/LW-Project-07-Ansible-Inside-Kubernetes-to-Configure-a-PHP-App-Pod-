FROM php:8.1-apache

# Install OpenSSH server and Python 3
RUN apt-get update && \
    apt-get install -y openssh-server python3 && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh>
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/s>

# Copy PHP file (optional)
COPY profile.php /var/www/html/

# Expose Apache and SSH ports
EXPOSE 80 22

# Start both Apache and SSH in foreground
CMD service ssh start && apache2-foreground
