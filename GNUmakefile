include /ioc/tools/driver.makefile
include $(EPICS_MODULES)/makeUtils/latest/utils.mk

MODULE=ecmccfg

LIBVERSION = MCS2

BUILDCLASSES = Linux
EXCLUDE_VERSIONS=3 7.0.3
ARCH_FILTER=RHEL%

SCRIPTS+=startup.cmd

HW_DIR = hardware/

DIRS += ${HW_DIR}Beckhoff_1XXX
DIRS += ${HW_DIR}Beckhoff_2XXX
DIRS += ${HW_DIR}Beckhoff_3XXX
DIRS += ${HW_DIR}Beckhoff_4XXX
DIRS += ${HW_DIR}Beckhoff_5XXX
DIRS += ${HW_DIR}Beckhoff_6XXX
DIRS += ${HW_DIR}Beckhoff_7XXX
DIRS += ${HW_DIR}Beckhoff_9XXX

# all scripts in Beckhoff_*XXX/* ending with 'cmd'
SCRIPTS += $(foreach d,${DIRS}, $(wildcard $d/*/*.cmd))

SCRIPTS+=$(wildcard ./scripts/*)
SCRIPTS+=$(wildcard ./general/*)
SCRIPTS+=$(wildcard ./hardware/*/*.cmd)
SCRIPTS+=$(wildcard ./motion/*)
SCRIPTS+=$(wildcard ./protocol/*)

TEMPLATES+=$(wildcard ./db/*.db)
TEMPLATES+=$(wildcard ./db/*.template)
TEMPLATES+=$(wildcard ./db/*.substitutions)
TEMPLATES+=$(wildcard ./db/*.subs)
TEMPLATES+=$(wildcard ./db/*/*.db)
TEMPLATES+=$(wildcard ./db/*/*.template)
TEMPLATES+=$(wildcard ./db/*/*.substitutions)
TEMPLATES+=$(wildcard ./db/*/*.subs)
