#-d /**
#-d   \brief hardware script for EP7211-0034
#-d   \details EP7211-0034 Servo terminal with OCT feedback
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: EP7211-0034 Servo terminal with OCT feedback
#-
#-  Note: The sync mode can not be written to in newer firmwares:
#-        (0x1C32,0x1,0x1C33,0x1). So then these lines below needs
#-        to be removed or commented out.
#-        The log will then show error like:
#-           EtherCAT ERROR 0-46: SDO download 0x1C32:01 (2 bytes) aborted.
#-           EtherCAT ERROR 0-46: SDO abort message 0x06090030: "Value range of parameter exceeded".
#-           EtherCAT ERROR 0-46: SDO configuration failed.
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7211-0034_CSP")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c2b4052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,16,CONTROL)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7010,0x05,32,1,SET_POSITION)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,32,POSITION)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,16,STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6010,0x07,32,VELOCITY)"

#- ############ Distributed clocks config EP7211:
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS_HALF",${ECMC_TEMP_PERIOD_NANO_SECS}/2)

#- NOTE important the sync 1 period needs to be 0!
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,${ECMC_TEMP_PERIOD_NANO_SECS},${ECMC_TEMP_PERIOD_NANO_SECS_HALF},0,0)"

# Peak current (to be overwritten by motor config)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,1000,4)"

ecmcEpicsEnvSetCalc("ECMC_TEMP_WHATCHDOG_1",1000/${ECMC_EC_SAMPLE_RATE=1000}*1000)
ecmcEpicsEnvSetCalc("ECMC_TEMP_WHATCHDOG_2",${ECMC_TEMP_WHATCHDOG_1}*10)

ecmcConfigOrDie "Cfg.EcSlaveConfigWatchDog(${ECMC_EC_SLAVE_NUM},${ECMC_TEMP_WHATCHDOG_1},${ECMC_TEMP_WHATCHDOG_2})"

# NOTE: Sometimes the EP7211-0034 will not go to op with the following error in /var/log/messages:
# Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C32:01 (2 bytes) aborted.
# Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see below 0x1c33

#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x1,3,2)"
#- Cycle time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

# NOTE: Sometimes the EP7211-0034 will not go to op with the following error in /var/log/messages:
# Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C33:01 (2 bytes) aborted.
# Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see above 0x1c32
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x1,3,2)"
#- Cycle time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

#- Activly choose CSP mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,8,1)"

#- Set used pdos
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1600,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1606,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"

epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1A00,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1A01,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1A02,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,3,1)"

epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS_HALF)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_1)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_2)
