################################################################################
#-------------- Information:
# Description: ecmccfg startup.script
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
################################################################################
#
# Arguments
# [mandatory]
# SYS
#
# [optional]
# ECMC_VER          = 6.0
# EthercatMC_VER    = 3.0
# INIT              = initAll
# MASTER_ID         = 0
# SCRIPTEXEC        = iocshLoad
#
# [set by module]
# ECMC_CONFIG_ROOT  = root directory of ${MODULE}
# ECMC_CONFIG_DB    = database directory of ${MODULE}
# EthercatMC_DB     = database directory of EthercatMC
#
#-------------------------------------------------------------------------------
# load required modules
require ecmc        "${ECMC_VER=6.0}"
require EthercatMC  "${EthercatMC_VER=3.0}"
# stream was moved to GNUmakefile 'REQUIRED', this removes the ability to load a specific stream_VER!!!
# require stream      "${stream_VER=kivel}"
#
#-------------------------------------------------------------------------------
# define default PATH for scripts and database/templates
epicsEnvSet("ECMC_CONFIG_ROOT",     "${ecmccfg_DIR}")
epicsEnvSet("ECMC_CONFIG_DB",       "${ecmccfg_TEMPLATES}/")
epicsEnvSet("EthercatMC_DB",        "${EthercatMC_TEMPLATES}/")
epicsEnvSet("STREAM_PROTOCOL_PATH", "${STREAM_PROTOCOL_PATH=""}:${ECMC_CONFIG_ROOT}:${ecmccfg_DB}")
# define command for script execution, PSI: <3.15 runScript(), else like for ESS: iocshLoad()
epicsEnvSet("SCRIPTEXEC",           "${SCRIPTEXEC=iocshLoad}")
#
#-------------------------------------------------------------------------------
# define IOC Prefix
epicsEnvSet("SM_PREFIX",            "${IOC}:")    # colon added since IOC is _not_ PREFIX
#-------------------------------------------------------------------------------
# call init-script, defaults to 'initAll'
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}${INIT=initAll}.cmd"
#
#-------------------------------------------------------------------------------
# add master (defaults to '0')
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}addMaster.cmd", "MASTER_ID=${MASTER_ID=0}"
#
# Ensure that this command is not executed twice (ESS vs PSI)
epicsEnvSet("ECMCCFG_INIT" ,"#")
