#!/lib/superatmos/root/busybox sh

if /lib/superatmos/root/busybox [ ! -f /system/cfroot/release-100-DZKL3- ]; 
then

# Remount system RW
/lib/superatmos/root/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system

# Just in case ...
/lib/superatmos/root/busybox mkdir /system/xbin
/lib/superatmos/root/busybox chmod 755 /system/xbin

# install root
/lib/superatmos/root/busybox cp /lib/superatmos/root/su /system/xbin
/lib/superatmos/root/busybox chown root.shell /system/xbin/su
/lib/superatmos/root/busybox chmod 4755 /system/xbin/su

# install Superuser app
/lib/superatmos/root/busybox cp /lib/superatmos/root/Superuser.apk /system/app/Superuser.apk
/lib/superatmos/root/busybox chown root.shell /system/app/Superuser.apk
/lib/superatmos/root/busybox chmod 644 /system/app/Superuser.apk

# CWM Manager

/lib/superatmos/root/busybox cp /lib/superatmos/root/CWMManager.apk /system/app/CWMManager.apk
/lib/superatmos/root/busybox chown root.shell /system/app/CWMManager.apk
/lib/superatmos/root/busybox chmod 644 /system/app/CWMManager.apk

# Additional modules support
/lib/superatmos/root/busybox mkdir /system/lib
/lib/superatmos/root/busybox chown root.shell /system/lib
/lib/superatmos/root/busybox chmod 755 /system/lib
/lib/superatmos/root/busybox mkdir /system/lib/modules
/lib/superatmos/root/busybox chown root.shell /system/lib/modules
/lib/superatmos/root/busybox chmod 755 /system/lib/modules
/lib/superatmos/root/busybox mkdir /data/lib
/lib/superatmos/root/busybox chown root.shell /data/lib
/lib/superatmos/root/busybox chmod 755 /data/lib
/lib/superatmos/root/busybox mkdir /data/lib/modules
/lib/superatmos/root/busybox chown root.shell /data/lib/modules
/lib/superatmos/root/busybox chmod 755 /data/lib/modules

# create init.d folders
/lib/superatmos/root/busybox mkdir /system/etc
/lib/superatmos/root/busybox mkdir /data/etc
/lib/superatmos/root/busybox mkdir /system/etc/init.d
/lib/superatmos/root/busybox mkdir /data/etc/init.d


# Once be enough
    toolbox mkdir /system/cfroot
    toolbox chmod 755 /system/cfroot
    toolbox rm /data/cfroot/*
    toolbox rmdir /data/cfroot
    toolbox rm /system/cfroot/*
    echo 1 > /system/cfroot/release-100-DZKL3-

#Remount system RO
/lib/superatmos/root/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system

fi;

# end
