include $(BR2_EXTERNAL_RECALBOX_PATH)/package/compiler-commons/compiler-commons.mk
include $(sort $(wildcard $(BR2_EXTERNAL_RECALBOX_PATH)/package/*/*.mk))
