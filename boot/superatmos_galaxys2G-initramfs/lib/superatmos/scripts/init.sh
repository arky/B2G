#!/lib/superatmos/root/busybox sh

# cf-root custom kernel properties
/lib/superatmos/root/busybox sh /lib/superatmos/scripts/properties.sh

# root install script
/lib/superatmos/root/busybox sh /lib/superatmos/scripts/instroot.sh



# custom bootup scripts for use by the user
if [ -f /system/customboot.sh ];
then
  /lib/superatmos/root/busybox sh /system/customboot.sh
fi;
if [ -f /data/customboot.sh ];
then
  /lib/superatmos/root/busybox sh /data/customboot.sh
fi;

# init.d
/lib/superatmos/root/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
chmod 777 /system/etc/init.d/*
if cd /system/etc/init.d >/dev/null 2>&1 ; then
  for file in * ; do
    if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
    /sbin/busybox sh "$file"
  done
fi
chmod 777 /data/etc/init.d/*
if cd /data/etc/init.d >/dev/null 2>&1 ; then
  for file in * ; do
    if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
    /sbin/busybox sh "$file"
  done
fi

/lib/superatmos/root/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
