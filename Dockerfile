FROM archlinux/base
MAINTAINER Rock Zhang "rockzhang@ciandt.com"
RUN pacman -Syyu --noconfirm \
 && pacman-db-upgrade \
 && pacman -S --noconfirm git jre8-openjdk jre8-openjdk-headless libxext libxrender libxtst sudo rsync base-devel freetype2 \
 && useradd -m -s /bin/bash docker \
 && mkdir -p /home/docker \
 && chown -R docker.docker /home/docker \
 && echo "docker ALL=(root)  NOPASSWD:ALL" >> /etc/sudoers \
 && echo '#!/bin/bash' >> /usr/bin/start.sh \
 && echo '[[ $(id -u docker) != ${UID:-1000} ]] && sudo usermod -u ${UID:-1000} docker' >> /usr/bin/start.sh \
 && echo '[[ $(id -g docker) != ${GID:-1000} ]] && sudo groupmod -g ${GID:-1000} docker' >> /usr/bin/start.sh \
 && echo "/opt/phpstorm/bin/phpstorm.sh" >> /usr/bin/start.sh \
 && chmod +x /usr/bin/start.sh
USER docker
RUN cd /home/docker \
 && git clone https://aur.archlinux.org/phpstorm.git \
 && cd phpstorm \
 && makepkg -si --noconfirm \
 && cd /home/docker \
 && sudo pacman -Scc --noconfirm  \
 && sudo rm -rf /home/docker/phpstorm
CMD /usr/bin/start.sh
