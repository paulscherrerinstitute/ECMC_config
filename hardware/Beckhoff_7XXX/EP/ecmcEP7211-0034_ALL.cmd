#-d /**
#-d   \brief hardware script for EP7211-0034
#-d   \details EP7211-0034 Servo terminal with OCT feedback and touch probe inputs
#-d   \author Niko Kivel, based on intial work by Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7211-0034_ALL")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c2b4052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- info data
#-   1: Torque current (filtered 1ms) [1000th of rated current]
#-   2: DC link voltage [mV]
#-   4: PCB temperature [0.1 °C]
#-   8: Errors: see docu for details
#-  16: Warnings: see docu for details
#-  32: I2T Motor [%]
#-  64: I2T Amplifier [%]
#- 128: Input Level: see doc for details

#- info data 01: DC voltage [mV]
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x39,2,1)"
#- info data 01: PCB Temp [1/10 degC]
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3A,4,1)"

#- SyncManager 2
#- 0x1600 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,16,CONTROL)"
#- 0x1601 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x06,32,1,VELOCITY_SETPOINT)"
#- SyncManager 3
#- 0x1A00 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,32,POSITION)"
#- 0x1A01 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,16,STATUS)"
#- 0x1A02 DRV Velocity actual value
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6010,0x07,S32,velocityActual01)"
#- 0x1A03 DRV Torque actual value
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x08,S16,torqueActual01)"
#- 0x1A04 DRV Info data 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x12,U16,infoData01)"
#- 0x1A05 DRV Info data 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,U16,infoData02)"
#- 0x1A06 DRV Following error actual value --> not really useful in CSV-mode
#- ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a06,0x6010,0x09,S32,followingError01)"
#- 0x1A07 FB Touch probe status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6001,0x01,U16,touchProbeStatus01)"

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

#- NOTE: Sometimes the EP7211-0034 will not go to op with the following error in /var/log/messages:
#- Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C32:01 (2 bytes) aborted.
#- Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see below 0x1c33
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x1,3,2)"
#- Cycle time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

#- NOTE: Sometimes the EP7211-0034 will not go to op with the following error in /var/log/messages:
#- Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C33:01 (2 bytes) aborted.
#- Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see above 0x1c32
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x1,3,2)"
#- Cycle time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS_HALF)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_1)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_2)
