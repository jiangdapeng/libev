_pwd := $(pwd)

include $(make-common.dir)/tool/cc.mk
include $(make-common.dir)/tool/cp.mk
include $(make-common.dir)/layout.mk

######################################################################
# Build libev.so:
_lib  := $(lib.dir)/libev.so
_objs := $(call cc.c.to.o,$(addprefix $(_pwd)/, \
  ev.c event.c \
))

all:      | $(_lib)
$(_objs): $(tmp.src.dir)/ev-config/config.h | ev.headers
$(_lib): cc.include.dirs += $(tmp.src.dir)/ev-config $(_pwd)
$(_lib): $(_objs)
	$(cc.so.rule)

######################################################################
# Export headers:
.PHONY: ev.headers
$(include.dir)/%.h: $(_pwd)/%.h
	$(cp.rule)

all: | ev.headers
ev.headers: $(addprefix $(include.dir)/, \
  ev.h ev++.h event.h \
)

# Generate config.h:
$(tmp.src.dir)/ev-config/config.h: $(_pwd)/configure
	@mkdir -p $(dir $@)
	cd $(dir $@) && $<
