#-d /**
#-d   \brief hardware script for EL3602
#-d   \details 2-channel 24bit analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d
#-d   Minimum sample time          = 20000ns  (oversampling rate of 50 in 1kHz ec rate)
#-d   Maximum Oversampling factor  = 100      (if ec rate is 500Hz then a NELM of 100 can be used)
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3602")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50219329")
epicsEnvSet("ECMC_OVER_SAMP_MAX"         "100")
epicsEnvSet("ECMC_SAMP_TIME_MIN"         "20000")

#- ############################################

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE. MAX NELM is 100 
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=${ECMC_OVER_SAMP_MAX}, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

#- Check valid minimum sampling time for a certain NELM and ECMC_EC_SAMPLE_RATE. Needs to higher than 50000
ecmcFileExist(${ecmccfg_DIR}chkOverSampTimeOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampTimeOrDie.cmd, "SAMP_TIME_MIN=${ECMC_SAMP_TIME_MIN}, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############################################

#- ############ Calc memmap size (each element is 4 bytes (32bits))
ecmcEpicsEnvSetCalc("ECMC_EC_ARRAY_BYTE_SIZE",${NELM=1}*4)

#- Different pdo index depending on sampling rate.. 
#- NELM    PDO index dec
#- 1       0xA01     1 
#- 2       0xA02     2
#- 4       0xA03     3
#- 5       0xA04     4
#- 8       0xA05     5
#- 10      0xA06     6
#- 16      0xA07     7
#- 20      0xA08     8
#- 25      0xA09     9
#- 32      0xA0A     10
#- 40      0xA0B     11
#- 50      0xA0C     12
#- 64      0xA0D     13
#- 80      0xA0E     14
#- 100     0xA0F     15
#- Check if valid NELM and set ECMC_PDO_TEMP to correct value according to list
#- Try to simulate switch statement

epicsEnvSet(ECMC_PDO_TEMP,"-1")
epicsEnvSet(ECMC_PDO_NELM_FOUND,"")
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=1 and ${ECMC_PDO_TEMP}==-1", "1","-1")
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=2 and ${ECMC_PDO_TEMP}==-1", "2","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=4 and ${ECMC_PDO_TEMP}==-1", "3","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=5 and ${ECMC_PDO_TEMP}==-1", "4","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=8 and ${ECMC_PDO_TEMP}==-1", "5","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=10 and ${ECMC_PDO_TEMP}==-1", "6","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=16 and ${ECMC_PDO_TEMP}==-1", "7","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=20 and ${ECMC_PDO_TEMP}==-1", "8","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=25 and ${ECMC_PDO_TEMP}==-1", "9","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=32 and ${ECMC_PDO_TEMP}==-1", "10","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=40 and ${ECMC_PDO_TEMP}==-1", "11","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=50 and ${ECMC_PDO_TEMP}==-1", "12","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=64 and ${ECMC_PDO_TEMP}==-1", "13","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=80 and ${ECMC_PDO_TEMP}==-1", "14","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=100 and ${ECMC_PDO_TEMP}==-1", "15","-1")

#- Ensure that ECMC_PDO_TEMP is set
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM and PDO is valid (${ECMC_PDO_TEMP}).","ecmcExit Error: NELM not valid => PDO not set..")
#- Exit if not valid according to
${ECMC_PDO_NELM_FOUND}

#- Convert to hex
ecmcEpicsEnvSetCalc("ECMC_PDO_CH1",${ECMC_PDO_TEMP},"0x1A%02x")
epicsEnvShow(ECMC_PDO_CH1)

#-  CH 1
epicsEnvSet("ECMC_CH"             "1")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,16,CH${ECMC_CH}_CONTROL)"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,S32,CH${ECMC_CH}_STATUS)"
#- Inflate all pdos with a for loop
epicsEnvSet("ECMC_EC_ENTRY"       "0x6001")
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_CH1}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH${ECMC_CH}_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,S64,CH${ECMC_CH}_TIMESTAMP)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,U32,CH${ECMC_CH}_TIMESTAMP_L32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x2,U32,CH${ECMC_CH}_TIMESTAMP_H32)"

#-  CH 2
epicsEnvSet("ECMC_CH"             "2")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x01,16,CH${ECMC_CH}_CONTROL)"

#-  Configuration for sync manager 3
#- Calculate PDO of ch2. ECMC_PDO_TEMP=ECMC_PDO_TEMP+33
ecmcEpicsEnvSetCalc("ECMC_PDO_CH2",${ECMC_PDO_TEMP}+33,"0x1A%02x")
epicsEnvShow(ECMC_PDO_CH2)
epicsEnvSet("ECMC_EC_ENTRY"       "0x6011")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a21,0x6010,0x1,S32,CH${ECMC_CH}_STATUS)"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_CH2}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.CH${ECMC_CH}_VALUE_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.CH${ECMC_CH}_ARRAY)"
#-ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a31,0x6015,0x1,S64,CH${ECMC_CH}_TIMESTAMP)"
#-ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a31,0x6015,0x1,U32,CH${ECMC_CH}_TIMESTAMP_L32)"
#-ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a31,0x6015,0x2,U32,CH${ECMC_CH}_TIMESTAMP_H32)"

#- ############ Configfigure DCs
#-  Cfg.EcSlaveConfigDC(
#-      int slave_bus_position,
#-      uint16_t assign_activate,
#-      uint32_t sync0_cycle,
#-      int32_t sync0_shift,
#-      uint32_t sync1_cycle,
#-      int32_t sync1_shift)
#- 
#- Sync configuration is not the same as in TwinCAT..
#-    sync0_cycle: Sample period in nanoseconds (for each sample). Example: EC_RATE 1000Hz, OVERSAMPLING_FACTOR=100 results in sync0_cycle=10000ns)
#-    sync1_cycle: EtherCAT sample period minus sync0_cycle.  Example: EC_RATE 1000Hz, OVERSAMPLING_FACTOR=100 results in sync1_cycle=990000ns)
#-

#- Seems the below is not needed. Maybe slave sort the timimg by itself based on the PDOs used.. Need to check..
#-ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_SYNC_0_CYCLE_NS",1/${ECMC_EC_SAMPLE_RATE=1000}*1E9/${NELM=1})
#-ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_SYNC_1_CYCLE_NS",1/${ECMC_EC_SAMPLE_RATE=1000}*1E9-${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS})
#-ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,${ECMC_EC_SLAVE_SYNC_0_CYCLE_NS},0,${ECMC_EC_SLAVE_SYNC_1_CYCLE_NS},0)"

#- Set used pdos (outputs)
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"

#- CH1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1600,2)"
#- CH2
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1601,2)"
#-PDO count
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"

#- Set used pdos (inputs)
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"

#- CH1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1A00,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,${ECMC_PDO_CH1},2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x1A10,2)"

#- CH2
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x4,0x1A21,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x5,${ECMC_PDO_CH2},2)"

#-PDO count
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,5,1)"

#-Default settings from startup list in TC (seems cannot be reset?)
#-#- CH1 
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x1,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x3,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x7,0,1)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x16,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x17,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x18,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x19,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x1A,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x1B,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x1C,0,1)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x2B,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x2C,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x2D,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8000,0x2E,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8005,0x1,0,4)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8005,0x2,65536,4)"
#-
#-#- CH2 
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x7,0,1)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x16,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x17,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x18,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1A,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1B,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1C,0,1)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2B,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2C,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2D,1,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2E,0,2)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8015,0x1,0,4)"
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8015,0x2,65536,4)"
#-
#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
epicsEnvUnset(ECMC_PDO_CH1)
epicsEnvUnset(ECMC_PDO_CH2)
epicsEnvUnset(ECMC_PDO_CH3)
epicsEnvUnset(ECMC_PDO_CH4)
epicsEnvUnset(ECMC_OVER_SAMP_MAX)
epicsEnvUnset(ECMC_SAMP_TIME_MIN)
