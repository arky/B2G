#!/bin/bash

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEVICE=galaxys2G
COMMON=common
MANUFACTURER=samsung

if [[ -z "${ANDROIDFS_I9100G_DIR}" ]]; then
    DEVICE_BUILD_ID=`adb shell cat /system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\r'`
else
    DEVICE_BUILD_ID=`cat ${ANDROIDFS_I9100G_DIR}/system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\r'`
fi

case "$DEVICE_BUILD_ID" in
"GINGERBREAD.UHKG7")
  FIRMWARE=UHKG7 ;;
"GINGERBREAD.XWKE7")
  FIRMWARE=XWKE7 ;;
"GINGERBREAD.UHKI2")
  FIRMWARE=UHKI2 ;;
"GINGERBREAD.XWKE2")
  echo 'Sorry, this firmware is too old (2.3.3).  Upgrade to 2.3.4.' >&2
  exit 1 ;;
"GINGERBREAD.ZSKI3")
  FIRMWARE=ZSKI3 ;;
"GWK74")
  FIRMWARE=GWK74 ;;
"GINGERBREAD.XWKI4")
  FIRMWARE=XWKI4 ;;
"GINGERBREAD.XWKJ2")
  FIRMWARE=XWKJ2 ;;
"GINGERBREAD.ZNKG5")
  FIRMWARE=ZNKG5 ;;
"GINGERBREAD.XXKI3")
  FIRMWARE=XXKI3 ;;
"GINGERBREAD.XXKI4")
  FIRMWARE=XXKI4 ;;
*)
  echo Your device has unknown firmware $DEVICE_BUILD_ID >&2
  ;;
esac

BASE_PROPRIETARY_COMMON_DIR=vendor/$MANUFACTURER/$COMMON/proprietary
PROPRIETARY_DEVICE_DIR=../../../vendor/$MANUFACTURER/$DEVICE/proprietary
PROPRIETARY_COMMON_DIR=../../../$BASE_PROPRIETARY_COMMON_DIR

mkdir -p $PROPRIETARY_DEVICE_DIR

for NAME in audio cameradata egl hw keychars wifi media ducati csc alsa bin vendor
do
    mkdir -p $PROPRIETARY_COMMON_DIR/$NAME
done

# galaxys2


# common
(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__MANUFACTURER__/$MANUFACTURER/g > ../../../vendor/$MANUFACTURER/$DEVICE/$DEVICE-vendor-blobs.mk
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Prebuilt libraries that are needed to build open-source libraries
PRODUCT_COPY_FILES := \\

# All the blobs necessary for galaxys2 devices
PRODUCT_COPY_FILES += \\

EOF

COMMON_BLOBS_LIST=../../../vendor/$MANUFACTURER/$COMMON/vendor-blobs.mk

(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__MANUFACTURER__/$MANUFACTURER/g > $COMMON_BLOBS_LIST
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Prebuilt libraries that are needed to build open-source libraries
PRODUCT_COPY_FILES := \\
    vendor/__MANUFACTURER__/__COMMON__/proprietary/libcamera.so:obj/lib/libcamera.so \\
    vendor/__MANUFACTURER__/__COMMON__/proprietary/libril.so:obj/lib/libril.so \\
    vendor/__MANUFACTURER__/__COMMON__/proprietary/libaudio.so:obj/lib/libaudio.so \\
    vendor/__MANUFACTURER__/__COMMON__/proprietary/libaudiopolicy.so:obj/lib/libaudiopolicy.so

# All the blobs necessary for galaxys2 devices
PRODUCT_COPY_FILES += \\
EOF

# copy_files
# pulls a list of files from the device and adds the files to the list of blobs
#
# $1 = list of files
# $2 = directory path on device
# $3 = directory name in $PROPRIETARY_COMMON_DIR
copy_files()
{
    for NAME in $1
    do
        echo Pulling \"$NAME\"
        if [[ -z "${ANDROIDFS_I9100G_DIR}" ]]; then
            adb pull /$2/$NAME $PROPRIETARY_COMMON_DIR/$3/$NAME
        else
           # Hint: Uncomment the next line to populate a fresh ANDROIDFS_I9100G_DIR
           #       (TODO: Make this a command-line option or something.)
           # adb pull /$2/$NAME ${ANDROIDFS_I9100G_DIR}/$2/$NAME
           cp ${ANDROIDFS_I9100G_DIR}/$2/$NAME $PROPRIETARY_COMMON_DIR/$3/$NAME
        fi

        if [[ -f $PROPRIETARY_COMMON_DIR/$3/$NAME ]]; then
            echo   $BASE_PROPRIETARY_COMMON_DIR/$3/$NAME:$2/$NAME \\ >> $COMMON_BLOBS_LIST
        else
            echo Failed to pull $NAME. Giving up.
            exit -1
        fi
    done
}

# copy_local_files
# puts files in this directory on the list of blobs to install
#
# $1 = list of files
# $2 = directory path on device
# $3 = local directory path
copy_local_files()
{
    for NAME in $1
    do
        echo Adding \"$NAME\"
        echo device/$MANUFACTURER/$DEVICE/$3/$NAME:$2/$NAME \\ >> $COMMON_BLOBS_LIST
    done
}

COMMON_LIBS="
	libaes.so
	libAMSOmaMmsChecker.so
	libAMSOmaWVGALibs.so
	lib_ARC_Omx_Plugin.so
	libarcomx_radec_sharedlibrary.so
	libarcomx_rvdec_sharedlibrary.so
	libarcsoft_bookmark.so
	libarcsoft_subtitle.so
	libaudiomodemgeneric.so
	libCopyPaste.so
	libd2cmap.so
	libdivxdrm.so
	libDmplayerE.so
	libDogEngine.so
	libdprw.so
	libdrmwrapper.so
	libdvm.so
	libext2_blkid.so
	libext2_com_err.so
	libext2_e2p.so
	libext2fs.so
	libext2_uuid.so
	libext4_utils.so
	libglcanvas.so
	libglyder2.so
	libhdcp.so
	libhdr.so
	libImmVibeJ.so
	libImmVibe.so
	libINVOKER.so
	libipc.so
	libipcutils.so
	libKiesDataRouter.so
	liblcdtest.so
	liblvmaservice.so
	libMapEngine46.so
	libmemmgr_rpc.so
	libmemmgr.so
	libmicrobes.so
	libmv2_getthumbnail.so
	libmv2_rm_dec.so
	libmv2_rmspliter.so
	libnativeEffect.so
	libnativeEraser.so
	libnative_resize.so
	libnativeUtils.so
	libnexadaptation_layer.so
	libnexaudiorenderer.so
	libnexplayersdk.so
	libnextreaming_aac_dl.so
	libnextreaming_ac3_dl.so
	libnextreaming_adpcm_dl.so
	libnextreaming_amrnb_dl.so
	libnextreaming_amrwb_dl.so
	libnextreaming_asp_dl.so
	libnextreaming_divx3_dl.so
	libnextreaming_drmss.so
	libnextreaming_flac_dl.so
	libnextreaming_mp3_dl.so
	libnextreaming_mpeg2_dl.so
	libnextreaming_ogg_dl.so
	libnextreaming_omap4_dl.so
	libnextreaming_pcm_dl.so
	libnextreaming_vp8_nx_dl.so
	libnextreaming_wma_dl.so
	libnextreaming_wmv_dl.so
	libnexvideodisplayer.so
	libnotify.so
	libObjectSel_JNI_Class.so
	libocont.so
	libOMX_CoreOsal.so
	libOMX_Core.so
	libomx_proxy_common.so
	libomx_rpc.so
	libOMX.TI.DUCATI1.IMAGE.JPEGD.so
	libOMX.TI.DUCATI1.MISC.SAMPLE.so
	libOMX.TI.DUCATI1.VIDEO.CAMERA.so
	libOMX.TI.DUCATI1.VIDEO.DECODER.so
	libOMX.TI.DUCATI1.VIDEO.H264D.so
	libOMX.TI.DUCATI1.VIDEO.H264E.so
	libOMX.TI.DUCATI1.VIDEO.MPEG4D.so
	libOMX.TI.DUCATI1.VIDEO.MPEG4E.so
	libOMX.TI.DUCATI1.VIDEO.VP6D.so
	libOMX.TI.DUCATI1.VIDEO.VP7D.so
	libplayready.so
	libpn544_fw.so
	libquickview.so
	libquramimagecodec.so
	lib_R2VS_ARM_GA_Library_for_Aries.so
	librcm.so
	libRtEngine50.so
	libRtEngine.so
	libSamsungPDLComposer.so
	libsavsac.so
	libsavscmn.so
	libsavsvc.so
	libscreencapture.so
	libsec_km.so
	libsecmediarecorder.so
	libsecMoSecurity.so
	libsensoraiding.so
	libsensor_yamaha_test.so
	libsig.so
	libsisodrm.so
	libsthmb.so
	libsysmgr.so
	libtiutils.so
	libTtsEngine.so
	libttssmt.so
	libvideieditor.so
	libvtmanager.so
	libvtstack.so
	libwebcore.so
	libwlbrcmp2papp.so
	libwldhcp.so
	libwlp2p.so
	libwlwpscli.so
	libwlwps.so
	libwmlscriptcore.so
	libXIVCoder.so
	libasound.so
	libsamsungSoundbooster.so
	lib_Samsung_Sound_Booster.so
	libsamsungAcousticeq.so
	lib_Samsung_Acoustic_Module_Llite.so
	liblvvefs.so
	lib_Samsung_Resampler.so
	libseccameraadaptor.so
	libcamera.so
	libtiutils.so
	libmemmgr.so
	libPanoraMax3.so
	libarccamera.so
	libActionShot.so
	libcaps.so
	libexifa.so
	libjpega.so
	libsecjpeginterface.so
	libsecjpeginterface.so
	libsecjpegboard.so
	libsecjpegarcsoft.so
	libhdr.so
	libquramimagecodec.so
	libnfc_ndef.so
	libstagefright_enc_common.so
	libstagefright_foundation.so
	libarcplatform.so
	libarcomx_omxcore_sharedlibrary.so
	libsecril-client.so
	libjpeg.so
	libstagefright.so
	libstagefright_omx.so
	libstagefright_color_conversion.so
	libstagefright_avc_common.so
	libstagefright_amrnb_common.so
	libemoji.so
	libcameraservice.so
	libsqlite.so
	libvorbisidec.so
	libaudio.so
	libeffects.so
	libaudiopolicy.so
	libskiagl.so
	libskia.so
	libETC1.so
	libGLESv2.so
	libGLESv1_CM.so
	libnativehelper.so
	libicui18n.so
	libwpa_client.so
	libril.so
	"
COMMON_MINI_LIBS="
	libaudio.so
	libaudiopolicy.so
	libcamera.so
	libril.so
	libsec-ril.so
	libasound.so
	lib_Samsung_Acoustic_Module_Llite.so
	lib_Samsung_Resampler.so 
	lib_Samsung_Sound_Booster.so
	libsamsungAcousticeq.so
	libsamsungSoundbooster.so
	libsecril-client.so
	libtiutils.so
	libaudiomodemgeneric.so 
	liblvvefs.so
	libmemmgr.so
	libmllite.so
	libmlplatform.so
	libmpl.so
	libhardware_legacy.so
	libhardware.so 
	libaudio.so
	libwpa_client.so
	libipcutils.so
	libipc.so
	librcm.so
	libnotify.so
	libsysmgr.so
	libfakecameraadapter.so
	libomxcameraadapter.so
	libusbcameraadapter.so
	"

#copy_files "$COMMON_LIBS" system/lib" ""
copy_files "$COMMON_MINI_LIBS" "system/lib" ""


BINARY="
	rild
	bluetoothd
	btld
	pvrsrvinit
	"

copy_files "$BINARY" "system/bin" "bin"

COMMON_CAMERADATA="
	RS_M5LS_C.bin
	RS_M5LS_O.bin
	RS_M5LS_SB.bin
	RS_M5LS_SC.bin
	RS_M5LS_T.bin
	"
copy_files "$COMMON_CAMERADATA" "system/cameradata" "cameradata"

COMMON_EGL="
	egl.cfg
	libGLES_android.so
	"

copy_files "$COMMON_EGL" "system/lib/egl" "egl"

VENDORLIBS="
	libglslcompiler.so
	libglslcompiler.so.1.1.17.4403
	libIMGegl.so
	libIMGegl.so.1.1.17.4403
	libpvr2d.so
	libpvr2d.so.1.1.17.4403
	libpvrANDROID_WSEGL.so
	libpvrANDROID_WSEGL.so.1.1.17.4403
	libPVRScopeServices.so
	libPVRScopeServices.so.1.1.17.4403
	libsrv_init.so
	libsrv_init.so.1.1.17.4403
	libsrv_um.so
	libsrv_um.so.1.1.17.4403
	libusc.so
	libusc.so.1.1.17.4403
	"
copy_files "$VENDORLIBS" "system/vendor/lib" "vendor"

VENDORLIBS_EGL="
	libEGL_POWERVR_SGX540_120.so
	libEGL_POWERVR_SGX540_120.so.1.1.17.4403
	libGLESv1_CM_POWERVR_SGX540_120.so
	libGLESv1_CM_POWERVR_SGX540_120.so.1.1.17.4403
	libGLESv2_POWERVR_SGX540_120.so
	libGLESv2_POWERVR_SGX540_120.so.1.1.17.4403
	"
copy_files "$VENDORLIBS_EGL" "system/vendor/lib/egl" "vendor"

VENDORLIBS_HW="
	gralloc.omap4.so
	gralloc.omap4.so.1.1.17.4403
	"
copy_files "$VENDORLIBS_HW" "system/vendor/lib/hw" "vendor"

COMMON_HW="
	acoustics.default.so
	alsa.default.so
	alsa.omap4.so
	gps.omap4.so
	gralloc.default.so
	lights.omap4.so
	overlay.omap4.so
	sensors.omap4.so
	"
copy_files "$COMMON_HW" "system/lib/hw" "hw"

COMMON_IDC="
	melfas_ts.idc
	qwerty2.idc
	sec_touchscreen.idc
	mxt224_ts_input.idc
	qwerty.idc
	"
copy_local_files "$COMMON_IDC" "system/usr/idc" "idc"

COMMON_KEYCHARS="
	qwerty2.kcm.bin
	qwerty.kcm.bin
	sec_key.kcm.bin
	sec_touchkey.kcm.bin
	"
copy_files "$COMMON_KEYCHARS" "system/usr/keychars" "keychars"

COMMON_WIFI="
	bcm4330_aps.bin
	bcm4330_mfg.bin
	bcm4330_sta.bin
	iwmulticall
	nvram_mfg.txt
	nvram_mfg.txt_murata
	nvram_net.txt
	nvram_net.txt_murata
	wifi.conf
	wl
	wpa_supplicant.conf
	"
copy_files "$COMMON_WIFI" "system/etc/wifi" "wifi"

COMMON_WIFI_LIBS="
	libhardware_legacy.so
	libnetutils.so
	"
copy_files "$COMMON_WIFI_LIBS" "system/lib" "wifi"

COMMON_MEDIA="
	battery_batteryerror.qmg
	battery_charging_100.qmg
	battery_charging_10.qmg
	battery_charging_15.qmg
	battery_charging_20.qmg
	battery_charging_25.qmg
	battery_charging_30.qmg
	battery_charging_35.qmg
	battery_charging_40.qmg
	battery_charging_45.qmg
	battery_charging_50.qmg
	battery_charging_55.qmg
	battery_charging_5.qmg
	battery_charging_60.qmg
	battery_charging_65.qmg
	battery_charging_70.qmg
	battery_charging_75.qmg
	battery_charging_80.qmg
	battery_charging_85.qmg
	battery_charging_90.qmg
	battery_charging_95.qmg
	battery_error.qmg
	bootsamsungloop.qmg
	bootsamsung.qmg
	chargingwarning.qmg
	Disconnected.qmg
	odeanim.qmg
	ODEAnim.zip
	"

copy_files "$COMMON_MEDIA" "system/media" "media"

DUCATI="
	base_image_app_m3.xem3
	base_image_sys_m3.xem3
	Notify_MPUAPP_reroute_Test_Core1.xem3
	Notify_MPUSYS_reroute_Test_Core0.xem3
	Notify_MPUSYS_Test_Core0.xem3
	"
copy_files "$DUCATI" "system/ducati" "ducati"

DUCATI_DCCID43="
	cid43_imx060_alg_3a_ae_dcc.bin
	cid43_imx060_alg_3a_ae_dcc.BIN
	cid43_imx060_alg_3a_ae_ti2_dcc.bin
	cid43_imx060_alg_3a_ae_ti2_dcc.BIN
	cid43_imx060_alg_3a_af_affw_dcc.bin
	cid43_imx060_alg_3a_af_affw_dcc.BIN
	cid43_imx060_alg_3a_af_caf_dcc.bin
	cid43_imx060_alg_3a_af_caf_dcc.BIN
	cid43_imx060_alg_3a_af_hllc_dcc.bin
	cid43_imx060_alg_3a_af_hllc_dcc.BIN
	cid43_imx060_alg_3a_af_saf_dcc.bin
	cid43_imx060_alg_3a_af_saf_dcc.BIN
	cid43_imx060_alg_adjust_rgb2rgb_dcc.bin
	cid43_imx060_alg_adjust_rgb2rgb_dcc.BIN
	cid43_imx060_awb_alg_ti3_tuning.bin
	cid43_imx060_awb_alg_ti3_tuning.BIN
	cid43_imx060_ducati_awb_ti2_tun.bin
	cid43_imx060_ducati_awb_ti2_tun.BIN
	cid43_imx060_ducati_eff_tun.bin
	cid43_imx060_ducati_eff_tun.BIN
	cid43_imx060_ducati_gamma.bin
	cid43_imx060_ducati_gamma.BIN
	cid43_imx060_ducati_lsc_2d.bin
	cid43_imx060_ducati_lsc_2d.BIN
	cid43_imx060_ducati_nsf_ldc.bin
	cid43_imx060_ducati_nsf_ldc.BIN
	cid43_imx060_h3a_aewb_dcc.bin
	cid43_imx060_h3a_aewb_dcc.BIN
	cid43_imx060_ipipe_3d_lut_dcc.bin
	cid43_imx060_ipipe_3d_lut_dcc.BIN
	cid43_imx060_ipipe_car_dcc.bin
	cid43_imx060_ipipe_car_dcc.BIN
	cid43_imx060_ipipe_cfai_dcc.bin
	cid43_imx060_ipipe_cfai_dcc.BIN
	cid43_imx060_ipipe_cgs_dcc.bin
	cid43_imx060_ipipe_cgs_dcc.BIN
	cid43_imx060_ipipe_dpc_lut_dcc.bin
	cid43_imx060_ipipe_dpc_otf.bin
	cid43_imx060_ipipe_dpc_otf.BIN
	cid43_imx060_ipipe_ee_dcc.bin
	cid43_imx060_ipipe_ee_dcc.BIN
	cid43_imx060_ipipe_gbce_dcc.bin
	cid43_imx060_ipipe_gbce_dcc.BIN
	cid43_imx060_ipipe_gic_dcc.bin
	cid43_imx060_ipipe_gic_dcc.BIN
	cid43_imx060_ipipe_lsc_poly_dcc.bin
	cid43_imx060_ipipe_lsc_poly_dcc.BIN
	cid43_imx060_ipipe_nf1_dcc.bin
	cid43_imx060_ipipe_nf1_dcc.BIN
	cid43_imx060_ipipe_nf2_dcc.bin
	cid43_imx060_ipipe_nf2_dcc.BIN
	cid43_imx060_ipipe_rgb2rgb_1_dcc.bin
	cid43_imx060_ipipe_rgb2rgb_1_dcc.BIN
	cid43_imx060_ipipe_rgb2rgb_2_dcc.bin
	cid43_imx060_ipipe_rgb2rgb_2_dcc.BIN
	cid43_imx060_ipipe_rgb2yuv_dcc.bin
	cid43_imx060_ipipe_rgb2yuv_dcc.BIN
	cid43_imx060_ipipe_rsz_dcc.bin
	cid43_imx060_ipipe_rsz_dcc.BIN
	cid43_imx060_ipipe_yuv444_to_yuv422_dcc.bin
	cid43_imx060_ipipe_yuv444_to_yuv422_dcc.BIN
	cid43_imx060_isif_clamp_dcc.bin
	cid43_imx060_isif_clamp_dcc.BIN
	cid43_imx060_isif_csc_dcc.bin
	cid43_imx060_isif_csc_dcc.BIN
	cid43_imx060_iss_glbce3_dcc.bin
	cid43_imx060_iss_glbce3_dcc.BIN
	cid43_imx060_iss_lbce_dcc.bin
	cid43_imx060_iss_lbce_dcc.BIN
	cid43_imx060_iss_scene_modes_dcc.bin
	cid43_imx060_iss_scene_modes_dcc.BIN
	cid43_imx060_iss_vstab_dcc.bin
	cid43_imx060_iss_vstab_dcc.BIN
	cid43_imx060_ldc_cac_cfg_dcc.bin
	cid43_imx060_ldc_cac_cfg_dcc.BIN
	cid43_imx060_ldc_cfg_dcc.bin
	cid43_imx060_ldc_cfg_dcc.BIN
	cid43_imx060_vnf_cfg_dcc.bin
	cid43_imx060_vnf_cfg_dcc.BIN
	cid43_kgen_dcc_preflash.bin
	cid43_kgen_dcc_preflash.BIN
	"
DUCATI_DCCID42="
	cid42_ov5650_alg_3a_ae_dcc.bin
	cid42_ov5650_alg_3a_ae_dcc.BIN
	cid42_ov5650_alg_3a_ae_ti2_dcc.bin
	cid42_ov5650_alg_3a_ae_ti2_dcc.BIN
	cid42_ov5650_alg_3a_af_affw_dcc.bin
	cid42_ov5650_alg_3a_af_affw_dcc.BIN
	cid42_ov5650_alg_3a_af_caf_dcc.bin
	cid42_ov5650_alg_3a_af_caf_dcc.BIN
	cid42_ov5650_alg_3a_af_hllc_dcc.bin
	cid42_ov5650_alg_3a_af_hllc_dcc.BIN
	cid42_ov5650_alg_3a_af_saf_dcc.bin
	cid42_ov5650_alg_3a_af_saf_dcc.BIN
	cid42_ov5650_alg_adjust_rgb2rgb_dcc.bin
	cid42_ov5650_alg_adjust_rgb2rgb_dcc.BIN
	cid42_ov5650_awb_alg_ti3_tuning.bin
	cid42_ov5650_awb_alg_ti3_tuning.BIN
	cid42_ov5650_ducati_awb_ti2_tun.bin
	cid42_ov5650_ducati_awb_ti2_tun.BIN
	cid42_ov5650_ducati_eff_tun.bin
	cid42_ov5650_ducati_eff_tun.BIN
	cid42_ov5650_ducati_gamma.bin
	cid42_ov5650_ducati_gamma.BIN
	cid42_ov5650_ducati_lsc_2d.bin
	cid42_ov5650_ducati_lsc_2d.BIN
	cid42_ov5650_ducati_nsf_ldc.bin
	cid42_ov5650_ducati_nsf_ldc.BIN
	cid42_ov5650_h3a_aewb_dcc.bin
	cid42_ov5650_h3a_aewb_dcc.BIN
	cid42_ov5650_ipipe_3d_lut_dcc.bin
	cid42_ov5650_ipipe_3d_lut_dcc.BIN
	cid42_ov5650_ipipe_car_dcc.bin
	cid42_ov5650_ipipe_car_dcc.BIN
	cid42_ov5650_ipipe_cfai_dcc.bin
	cid42_ov5650_ipipe_cfai_dcc.BIN
	cid42_ov5650_ipipe_cgs_dcc.bin
	cid42_ov5650_ipipe_cgs_dcc.BIN
	cid42_ov5650_ipipe_dpc_lut_dcc.bin
	cid42_ov5650_ipipe_dpc_lut_dcc.BIN
	cid42_ov5650_ipipe_dpc_otf.bin
	cid42_ov5650_ipipe_dpc_otf.BIN
	cid42_ov5650_ipipe_ee_dcc.bin
	cid42_ov5650_ipipe_ee_dcc.BIN
	cid42_ov5650_ipipe_gbce_dcc.bin
	cid42_ov5650_ipipe_gbce_dcc.BIN
	cid42_ov5650_ipipe_gic_dcc.bin
	cid42_ov5650_ipipe_gic_dcc.BIN
	cid42_ov5650_ipipe_lsc_poly_dcc.bin
	cid42_ov5650_ipipe_lsc_poly_dcc.BIN
	cid42_ov5650_ipipe_nf1_dcc.bin
	cid42_ov5650_ipipe_nf1_dcc.BIN
	cid42_ov5650_ipipe_nf2_dcc.bin
	cid42_ov5650_ipipe_nf2_dcc.BIN
	cid42_ov5650_ipipe_rgb2rgb_1_dcc.bin
	cid42_ov5650_ipipe_rgb2rgb_1_dcc.BIN
	cid42_ov5650_ipipe_rgb2rgb_2_dcc.bin
	cid42_ov5650_ipipe_rgb2rgb_2_dcc.BIN
	cid42_ov5650_ipipe_rgb2yuv_dcc.bin
	cid42_ov5650_ipipe_rgb2yuv_dcc.BIN
	cid42_ov5650_ipipe_rsz_dcc.bin
	cid42_ov5650_ipipe_rsz_dcc.BIN
	cid42_ov5650_ipipe_yuv444_to_yuv422_dcc.bin
	cid42_ov5650_ipipe_yuv444_to_yuv422_dcc.BIN
	cid42_ov5650_isif_clamp_dcc.bin
	cid42_ov5650_isif_clamp_dcc.BIN
	cid42_ov5650_isif_csc_dcc.bin
	cid42_ov5650_isif_csc_dcc.BIN
	cid42_ov5650_iss_glbce3_dcc.bin
	cid42_ov5650_iss_glbce3_dcc.BIN
	cid42_ov5650_iss_lbce_dcc.bin
	cid42_ov5650_iss_lbce_dcc.BIN
	cid42_ov5650_iss_scene_modes_dcc.bin
	cid42_ov5650_iss_scene_modes_dcc.BIN
	cid42_ov5650_iss_vstab_dcc.bin
	cid42_ov5650_iss_vstab_dcc.BIN
	cid42_ov5650_ldc_cac_cfg_dcc.bin
	cid42_ov5650_ldc_cac_cfg_dcc.BIN
	cid42_ov5650_ldc_cfg_dcc.bin
	cid42_ov5650_ldc_cfg_dcc.BIN
	cid42_ov5650_vnf_cfg_dcc.bin
	cid42_ov5650_vnf_cfg_dcc.BIN
	cid42_ov5650_vss_sac_smac_cfg_dcc.bin
	cid42_ov5650_vss_sac_smac_cfg_dcc.BIN
	"

copy_files "$DUCATI_DCCID42" "system/ducati/dcc/omapcam/R12_MVEN002_LD2_ND0_IR0_SH0_FL0_SVEN002_DCCID42" "ducati"

copy_files "$DUCATI_DCCID43" "system/ducati/dcc/omapcam/R12_MVEN001_LD1_ND0_IR0_SH0_FL0_SVEN001_DCCID43" "ducati"

SYSLINK="
	syslink_daemon.out
	syslink_tilertest.out
	syslink_trace_daemon.out
	"
copy_files "$SYSLINK" "system/bin" "ducati"

CSCFILES="
	sales_code.dat
	"
copy_files "$CSCFILES" "system/csc" "csc"


ALSA="
     alsa.conf
     "

copy_files "$ALSA" "system/usr/share/alsa" "alsa"

ALSACARDS="
	aliases.conf
	"

copy_files "$ALSACARDS" "system/usr/share/alsa/cards" "alsa"


ALSAPCM="
	center_lfe.conf
	default.conf
	dmix.conf
	dpl.conf
	dsnoop.conf
	front.conf
	iec958.conf
	modem.conf
	rear.conf
	side.conf
	surround40.conf
	surround41.conf
	surround50.conf
	surround51.conf
	surround71.conf
	"

copy_files "$ALSAPCM" "system/usr/share/alsa/pcm" "alsa"

./setup-makefiles.sh
