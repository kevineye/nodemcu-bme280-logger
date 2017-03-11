SRC_FILES := \
    lib/config.lua \
    lib/init.lua \
    lib/log.lua \
    lib/mqtt-connect.lua \
    lib/ready.lua \
    lib/sensors.lua \
    lib/sensors-read.lua \
    lib/telnet.lua \
    lib/wifi-connect.lua \
    app.lua \
    config.json

include lib/Makefile.mk
