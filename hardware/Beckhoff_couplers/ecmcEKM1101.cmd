#-d /**
#-d   \brief hardware script for EKM1101
#-d   \details EKM1101 EtherCAT Coupler  (2A E-Bus, ID switch, Diagnostics, ...)
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EKM1101")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x4fe17cd9")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- Alias = 0
ecmcConfigOrDie "Cfg.EcAddSlave(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,16,DEV_CONTROL)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,8,DEV_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x9,8,DEV_ID)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a20,0x6010,0x1,16,ACC_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a20,0x6010,0x11,16,ACC_SAMPLES)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a25,0x6015,0x1,16,ACC_X)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a26,0x6016,0x1,16,ACC_Y)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a27,0x6017,0x1,16,ACC_Z)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a28,0x6018,0x1,64,ACC_TS)"


ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a33,0x6050,0x1,16,CHUSIN_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a33,0x0000,0x0,16,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a33,0x6050,0x11,32,CHUSIN_VALUE)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a34,0x6060,0x1,16,CHUPIN_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a34,0x0000,0x0,16,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a34,0x6060,0x11,32,CHUPIN_VALUE)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a35,0x6070,0x1,16,CHUPOUT_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a35,0x0000,0x0,16,GAP)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a35,0x6070,0x11,32,CHUPOUT_VALUE)"

#   TxPDO 0x1a33 "MMS Voltage Us In TxPDO-Map"
#     PDO entry 0x6050:01,  1 bit, "Underrange"
#     PDO entry 0x6050:02,  1 bit, "Overrange"
#     PDO entry 0x6050:03,  2 bit, "Limit 1"
#     PDO entry 0x6050:05,  2 bit, "Limit 2"
#     PDO entry 0x6050:07,  1 bit, "Error"
#     PDO entry 0x0000:00,  7 bit, "Gap"
#     PDO entry 0x6050:0f,  1 bit, "TxPDO State"
#     PDO entry 0x6050:10,  1 bit, "TxPDO Toggle"
#     PDO entry 0x0000:00, 16 bit, "Gap"
#     PDO entry 0x6050:11, 32 bit, "Value"
#   TxPDO 0x1a34 "MMS Voltage Up In TxPDO-Map"
#     PDO entry 0x6060:01,  1 bit, "Underrange"
#     PDO entry 0x6060:02,  1 bit, "Overrange"
#     PDO entry 0x6060:03,  2 bit, "Limit 1"
#     PDO entry 0x6060:05,  2 bit, "Limit 2"
#     PDO entry 0x6060:07,  1 bit, "Error"
#     PDO entry 0x0000:00,  7 bit, "Gap"
#     PDO entry 0x6060:0f,  1 bit, "TxPDO State"
#     PDO entry 0x6060:10,  1 bit, "TxPDO Toggle"
#     PDO entry 0x0000:00, 16 bit, "Gap"
#     PDO entry 0x6060:11, 32 bit, "Value"
#   TxPDO 0x1a35 "MMS Voltage Up Out TxPDO-Map"
#     PDO entry 0x6070:01,  1 bit, "Underrange"
#     PDO entry 0x6070:02,  1 bit, "Overrange"
#     PDO entry 0x6070:03,  2 bit, "Limit 1"
#     PDO entry 0x6070:05,  2 bit, "Limit 2"
#     PDO entry 0x6070:07,  1 bit, "Error"
#     PDO entry 0x0000:00,  7 bit, "Gap"
#     PDO entry 0x6070:0f,  1 bit, "TxPDO State"
#     PDO entry 0x6070:10,  1 bit, "TxPDO Toggle"
#     PDO entry 0x0000:00, 16 bit, "Gap"
#     PDO entry 0x6070:11, 32 bit, "Value"
