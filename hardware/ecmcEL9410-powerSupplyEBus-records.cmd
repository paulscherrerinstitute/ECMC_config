${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}${HW_DESC}.cmd

ecmcAsynPortDriverAddParameter(${ECMC_ASYN_PORT},"ec${ECMC_EC_MASTER_ID}.s${ECMC_EC_SLAVE_NUM}.EBUS_UNDERVOLTAGE","asynInt32",${ECMC_ASYN_SKIP_CYCLES})
ecmcAsynPortDriverAddParameter(${ECMC_ASYN_PORT},"ec${ECMC_EC_MASTER_ID}.s${ECMC_EC_SLAVE_NUM}.POWER_UNDERVOLTAGE","asynInt32",${ECMC_ASYN_SKIP_CYCLES})

dbLoadRecords("${ECMC_CONFIG_DB}ecmcEL9410.template","P=${ECMC_PREFIX}, PORT=${ECMC_ASYN_PORT}, ADDR=${ECMC_ASYN_ADDR}, TIMEOUT=${ECMC_ASYN_TIMEOUT}, MASTER_ID=${ECMC_EC_MASTER_ID}, SLAVE_POS=${ECMC_EC_SLAVE_NUM}, HWTYPE=${ECMC_EC_HWTYPE}")