#!/lib/superatmos/root/busybox sh

# sdcard isn't mounted at this point, mount it for now
/lib/superatmos/root/busybox mount -o rw /dev/block/mmcblk0p11 /mnt/sdcard

if [ ! -f /data/.superatmos/efsbackup.tar.gz ];
then
  mkdir /data/.superatmos
  chmod 777 /data/.superatmos
  /sbin/busybox tar zcvf /data/.superatmos/efsbackup.tar.gz /efs
  /sbin/busybox cat /dev/block/mmcblk0p1 > /data/.superatmos/efsdev-mmcblk0p1.img
  /sbin/busybox gzip /data/.superatmos/efsdev-mmcblk0p1.img
  /sbin/busybox cp /data/.superatmos/efs* /mnt/sdcard
fi

# install custom boot animation
if [ -f /mnt/sdcard/superatmos/bootanimation.zip ]; then
  /lib/superatmos/root/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
  /lib/superatmos/root/busybox rm /system/media/bootanimation.zip
  /lib/superatmos/root/busybox cp /mnt/sdcard/superatmos/bootanimation.zip /system/media/bootanimation.zip
  /lib/superatmos/root/busybox rm /mnt/sdcard/superatmos/bootanimation.zip
  /lib/superatmos/root/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system
fi;

# install custom boot sound
if [ -f /mnt/sdcard/superatmos/PowerOn.wav ]; then
  /lib/superatmos/root/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
  /lib/superatmos/root/busybox rm /system/etc/PowerOn.wav
  /lib/superatmos/root/busybox cp /mnt/sdcard/superatmos/PowerOn.wav /system/etc/PowerOn.wav
  /lib/superatmos/root/busybox rm /mnt/sdcard/superatmos/PowerOn.wav
  /lib/superatmos/root/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system
fi;

# remove sdcard mount again
/lib/superatmos/root/busybox umount /mnt/sdcard
