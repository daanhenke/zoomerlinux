FROM archlinux/base:latest

# Install core dependencies
RUN pacman --noconfirm -Sy base base-devel archiso git

# Create builder user
RUN useradd builder

COPY iso /iso
COPY entrypoint.sh /entrypoint.sh

CMD [ "/entrypoint.sh" ]
ENTRYPOINT [ "/bin/bash" ]