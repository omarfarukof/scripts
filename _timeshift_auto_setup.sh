yay -S timeshift-autosnap
sudo nano /etc/timeshift-autosnap.conf


sudo pacman -S grub-btrfs
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo pacman -S inotify-tools

sudo systemctl edit --full grub-btrfsd
# ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto

sudo systemctl start grub-btrfsd
sudo systemctl enable grub-btrfsd
