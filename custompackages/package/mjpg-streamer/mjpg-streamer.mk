MJPG_STREAMER_VERSION = f13ef482835657778486a0a1d7172116dd29d695
MJPG_STREAMER_SITE = https://github.com/schneemaier/mjpg-streamer.git
MJPG_STREAMER_SITE_METHOD = git
MJPG_STREAMER_DEPENDENCIES =
# MJPG_STREAMER_CONF_OPTS = -DCMAKE_BUILD_TYPE=Debug
MJPG_STREAMER_SUBDIR = mjpg-streamer-experimental

define MJPG_STREAMER_TARGET_CLEANUP
	# remot WWW directory
	rm -rf $(TARGET_DIR)/usr/share/mjpg-streamer/www
	# remove unused mjpg stream input and output options
        rm -rf $(TARGET_DIR)/usr/lib/mjpg-streamer/input_file.so
        rm -rf $(TARGET_DIR)/usr/lib/mjpg-streamer/input_http.so
        rm -rf $(TARGET_DIR)/usr/lib/mjpg-streamer/input_uvc.so
        rm -rf $(TARGET_DIR)/usr/lib/mjpg-streamer/output_file.so
        rm -rf $(TARGET_DIR)/usr/lib/mjpg-streamer/output_rtsp.so
        rm -rf $(TARGET_DIR)/usr/lib/mjpg-streamer/output_udp.so
endef

MJPG_STREAMER_POST_INSTALL_TARGET_HOOKS += MJPG_STREAMER_TARGET_CLEANUP

$(eval $(cmake-package))
