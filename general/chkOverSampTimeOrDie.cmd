#==============================================================================
#-d /** chkOverSampleTimeOrDie.cmd
#-d
#-d   \brief Checks if the resulting sampling time for oversampling slaves is higher or equal to the minimum time.
#-d   if not the exit IOC.
#-d   
#-d   Some oversampling slaves might support higher oversampling rates if the ethercat cycletime is lowered.
#-d   For instance a ELM3604 can support a NELM of 1000 if the ec sampling rate is 200Hz but only support NELM=20 if ec rate is 1kHz.
#-d   
#-d   \author Anders Sandstroem
#-d
#-d    Arguments: 
#-d      SAMP_TIME_MIN :  Minimum sampling rate for this slave [ns]
#-d      OVER_SAMP_REQ :  Requested Oversampling factor for this terminal []
#-d      EC_SAMP       :  EtherCAT bus sampling rate in [Hz]
#-d      HW_TYPE       :  Hardware type
#-d      SLAVE_ID      :  Slave bus position
#-d
#-d   \file
#-d */
#
# Check EtherCAT sample rate is set and valid
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${EC_SAMP=-1}=-1", "ecmcExit Error: EtherCAT sampling rate undefined (${HW_TYPE} at bus position ${SLAVE_ID})","# EtherCAT sampling rate is defined: ${EC_SAMP}")
# Result: 
${ECMC_EXE_CMD}
#
ecmcEpicsEnvSetCalc(ECMC_ELEMENT_SAMP_TIME,"1/${EC_SAMP}*1E9/${OVER_SAMP_REQ}")

# Check that sampling period [ns] (for each sample in the terminal) is higher than SAMP_TIME_MIN
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${ECMC_ELEMENT_SAMP_TIME}<${SAMP_TIME_MIN}", "ecmcExit Error: Req. oversamp.rate (${OVER_SAMP_REQ}) and ethercat rate results in an element time rate lower than minimum (min=${SAMP_TIME_MIN}ns, requesed=${ECMC_ELEMENT_SAMP_TIME}ns) (${HW_TYPE} at bus position ${SLAVE_ID}).","# Element sample time valid: ${ECMC_ELEMENT_SAMP_TIME}>=${SAMP_TIME_MIN}")
# Result: 
${ECMC_EXE_CMD}
#-Cleanup
epicsEnvUnset(ECMC_ELEMENT_SAMP_TIME)
epicsEnvUnset(ECMC_EXE_CMD)
#
