#-d /**
#-d   \brief generic hardware script for Baumer EAx580
#-d   \details Encoder with EtherCAT interface
#-d   \author Niko Kivel
#-d   \file
#-d
#-d   Macros:
#-d     ECMC_EC_SLAVE_NUM         : Slave number
#-d     ECMC_EC_MASTER_ID         : Master id
#-d     ECMC_EC_SAMPLE_RATE       : EtherCAT sampling rate [Hz] (set in startup.cmd)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EAx580")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000000ec")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00000300")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############ Config PDOS, 0x1a00:
#- ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6004,0x00,U32,actPos0)"

#- ############ Config PDOS, 0x1a04:
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6004,0x00,U32,actPos)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x2004,0x00,U32,actVel)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x2000,0x00,U32,sysTimeLow32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6503,0x00,U16,alarms)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6505,0x00,U16,warnings)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x2120,0x00,S32,temperature)"

#- ############ Distributed clocks config EL7201:
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS_HALF",${ECMC_TEMP_PERIOD_NANO_SECS}/2)

#- NOTE important the sync 1 period needs to be 0!
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x300,${ECMC_TEMP_PERIOD_NANO_SECS},${ECMC_TEMP_PERIOD_NANO_SECS_HALF},0,0)"
