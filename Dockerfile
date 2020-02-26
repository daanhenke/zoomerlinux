FROM archlinux/base:latest

RUN pacman --noconfirm -Sy base base-devel archiso

COPY iso /iso
COPY entrypoint.sh /entrypoint.sh

CMD [ "/entrypoint.sh" ]
ENTRYPOINT [ "/bin/bash" ]