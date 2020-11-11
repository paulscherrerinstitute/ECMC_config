#- ecmcForLoop file for EL3702 oversampling PDOS
#- 
#-  Loop macro: 
#-    ECMC_LOOP_IDX    : Loop variable 1..OVERSAMPLING_FACTOR
#-
#-  Static macros (same for entire for loop): 
#-  CH_ID            : Channel id
#-  PDO_             : PDO
#-  ENTRY            : Entry 

#- Convert to hex value with zero padding (subtract one since addresses start from 0)
ecmcEpicsEnvSetCalc("ECMC_ENTRY_HEX_VALUE",${ECMC_LOOP_IDX},"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${PDO},${ENTRY},0x${ECMC_ENTRY_HEX_VALUE},S32,CH${CH_ID}_VALUE_${ECMC_LOOP_IDX},0)"
