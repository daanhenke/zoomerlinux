#!/bin/bash

set -e -u

USER_NAME=live
USER_PASS=zoomer
ROOT_PASS=zoomer

usermode()
{
    runuser -l $USER_NAME -c "$@"
}

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 -R /root

# Fix sudoers.d permissions
chown root:root -R /etc/sudoers.d

# Do user initialization
if ! id -u $USER_NAME > /dev/null 2>&1
then
    useradd -m -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/zsh $USER_NAME
fi
echo $USER_NAME:$USER_PASS | chpasswd
echo root:$ROOT_PASS | chpasswd
chown -R $USER_NAME /home/$USER_NAME

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service

# Enable lightdm on boot
systemctl set-default graphical.target
systemctl enable lightdm.service

# Setup pacman
pacman-key --init
pacman-key --populate

