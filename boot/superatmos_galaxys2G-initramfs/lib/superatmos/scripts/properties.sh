#!/lib/superatmos/root/busybox sh
/lib/superatmos/root/busybox mount -o remount,rw rootfs /
mkdir -p /customkernel/property 
echo true >> /customkernel/property/customkernel.cf-root 
echo true >> /customkernel/property/customkernel.base.cf-root 
echo SuperatmosKernel >> /customkernel/property/customkernel.name 
echo "SuperatmosKernel" >> /customkernel/property/customkernel.namedisplay 
echo 100 >> /customkernel/property/customkernel.version.number 
echo 5.0 >> /customkernel/property/customkernel.version.name 
echo true >> /customkernel/property/customkernel.bootani.zip 
echo true >> /customkernel/property/customkernel.bootani.bin 
echo true >> /customkernel/property/customkernel.cwm 
echo 5.0.2.7 >> /customkernel/property/customkernel.cwm.version 
/lib/superatmos/root/busybox mount -o remount,ro rootfs /
