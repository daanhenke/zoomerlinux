FROM archlinux/base:latest

RUN pacman --noconfirm -Sy base base-devel archiso

COPY iso /iso

CMD [ "/iso/build.sh", "-v" ]
ENTRYPOINT [ "/bin/bash" ]