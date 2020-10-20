#==============================================================================
# initAll.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for basic ECMC setup.
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */

#- call init.cmd
ecmcFileExist("${ECMC_CONFIG_ROOT}init.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}init.cmd

############################################################
############# ASYN Configuration:

epicsEnvSet("ECMC_MOTOR_PORT"     "${SM_MOTOR_PORT=MCU1}")
epicsEnvSet("ECMC_ASYN_PORT"      "${SM_ASYN_PORT=MC_CPU1}")
epicsEnvSet("ECMC_PREFIX"         "${SM_PREFIX=IOC2:}")

#- Create ECMC
ecmcAsynPortDriverConfigure(${ECMC_ASYN_PORT},${ECMC_ASYN_PORT_MAX_PARAMS=1000},0,0,${ECMC_SAMPLE_RATE_MS=100})

asynOctetSetOutputEos(${ECMC_ASYN_PORT}, -1, ";\n")
asynOctetSetInputEos(${ECMC_ASYN_PORT}, -1, ";\n")
asynSetTraceMask(${ECMC_ASYN_PORT}, -1, 0x41)
asynSetTraceIOMask(${ECMC_ASYN_PORT}, -1, 6)
asynSetTraceInfoMask(${ECMC_ASYN_PORT}, -1, 1)

#- Create motor record controller (keep 64 for use with EthercatMC)
${ECMC_MR_MODULE="ecmcMotorRecord"}CreateController(${ECMC_MOTOR_PORT}, ${ECMC_ASYN_PORT}, "64", ${ECMC_MR_MOV_POLL_MS=200}, ${ECMC_MR_IDLE_POLL_MS=1000}, "")

############################################################
############# Misc settings:
# Disable function call trace printouts
ecmcConfigOrDie "Cfg.SetEnableFuncCallDiag(0)"

# Disable on change printouts from objects (enable for easy logging)
ecmcConfigOrDie "Cfg.SetTraceMaskBit(15,0)"

# Choose to generate EPICS-records for EtherCAT-entries
# (For records use ECMC_GEN_EC_RECORDS="-records" otherwise ECMC_GEN_EC_RECORDS="")
epicsEnvSet("ECMC_GEN_EC_RECORDS",          "-records")

# Choose to generate EPICS-records for ax-entries (PosAct, SetPos,..)
# (For records use ECMC_GEN_AX_RECORDS="-records" otherwise ECMC_GEN_AX_RECORDS="")
epicsEnvSet("ECMC_GEN_AX_RECORDS",          "-records")

# Update records in 10ms (100Hz)
#epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "10")
