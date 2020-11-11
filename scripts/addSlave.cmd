#==============================================================================
# addSlave.cmd
#- Arguments: HW_DESC, [SLAVE_ID = 0]

#-d /**
#-d   \brief Script for adding a slave to the EtherCAT bus configuration.
#-d   \details Adds the respective hardware to the bus configuration, adds specific and default PV to the EPICS database. For some/most slaves also a default
#-d   \author Niko Kivel
#-d   \file
#-d   \param HW_DESC Hardware descriptor, i.e. EL1008
#-d   \param SLAVE_ID (optional) bus position
#-d   \param SUBST_FILE (optional) substitution file
#-d   \param NELM (optional) Used for oversampling cards. Defaults to 1
#-d   \note Example calls:
#-d   \note - call w/o SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7037"
#-d   \endcode
#-d   \note - call w/ SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL1018, SLAVE_ID=1"
#-d   \endcode
#-d   \pre A master has to be claimed by calling \b addMaster.cmd, which is typically done within the startup.script
#-d   \post After all slaves have been added to the bus configuration, \b applyConfig.cmd has to be called.
#-d */

epicsEnvSet("ECMC_EC_SLAVE_NUM",  "${SLAVE_ID=0}")
epicsEnvSet("HW_DESC",            "${HW_DESC}")
# add ${HW_DESC} to the bus at position ${SLAVE_ID}
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmc${HW_DESC}.cmd "NELM=${NELM=1}"
ecmcFileExist(${SUBST_FILE="ecmc${ECMC_EC_HWTYPE}.substitutions"},1,1)
dbLoadTemplate(${SUBST_FILE="ecmc${ECMC_EC_HWTYPE}.substitutions"},"P=${ECMC_PREFIX},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},NELM=${NELM=1}")
# increment SLAVE_ID
ecmcEpicsEnvSetCalc("SLAVE_ID", "${ECMC_EC_SLAVE_NUM}+1","%d")

