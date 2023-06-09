MJPG_STREAMER_VERSION = f13ef482835657778486a0a1d7172116dd29d695
MJPG_STREAMER_SITE = https://github.com/schneemaier/mjpg-streamer.git
MJPG_STREAMER_SITE_METHOD = git
MJPG_STREAMER_DEPENDENCIES =
# MJPG_STREAMER_CONF_OPTS = -DCMAKE_BUILD_TYPE=Debug
MJPG_STREAMER_SUBDIR = mjpg-streamer-experimental

define MJPG_STREAMER_TARGET_CLEANUP
	rm -rf $(TARGET_DIR)/usr/share/mjpg-streamer/www
endef
MJPG_STREAMER_POST_INSTALL_TARGET_HOOKS += MJPG_STREAMER_TARGET_CLEANUP

$(eval $(cmake-package))
