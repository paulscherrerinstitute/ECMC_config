#==============================================================================
# ecmc_axis.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for configuring a physical axis.
#-d   \details Configures a physical axis in ECMC, based on previously set environment variables.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note This script is typically called by \b addAxis.cmd, often via \b ecmc_axis-records.cmd
#-d   \pre An axis definition for a physical axis has to be added/configured immediately before the call of this script.
#-d */

#- General
ecmcConfigOrDie "Cfg.CreateAxis(${ECMC_AXIS_NO},1,${ECMC_DRV_TYPE})"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_AXIS_HEALTH},"ax${ECMC_AXIS_NO}.health")"
ecmcConfigOrDie "Cfg.SetAxisModRange(${ECMC_AXIS_NO}, ${ECMC_MOD_RANGE})"
ecmcConfigOrDie "Cfg.SetAxisModType(${ECMC_AXIS_NO}, ${ECMC_MOD_TYPE})"

#- Trajectory
ecmcConfigOrDie "Cfg.SetAxisEmergDeceleration(${ECMC_AXIS_NO},${ECMC_EMERG_DECEL})"
ecmcConfigOrDie "Cfg.SetAxisVelAccDecTime(${ECMC_AXIS_NO},${ECMC_VELO},${ECMC_ACCL})"
ecmcConfigOrDie "Cfg.SetAxisHomeVelTwordsCam(${ECMC_AXIS_NO},${ECMC_HOME_VEL_TO})"
ecmcConfigOrDie "Cfg.SetAxisHomeVelOffCam(${ECMC_AXIS_NO},${ECMC_HOME_VEL_FRM})"

#- Controller
ecmcConfigOrDie "Cfg.SetAxisCntrlKp(${ECMC_AXIS_NO},${ECMC_CNTRL_KP})"
ecmcConfigOrDie "Cfg.SetAxisCntrlKi(${ECMC_AXIS_NO},${ECMC_CNTRL_KI})"
ecmcConfigOrDie "Cfg.SetAxisCntrlKd(${ECMC_AXIS_NO},${ECMC_CNTRL_KD})"
ecmcConfigOrDie "Cfg.SetAxisCntrlKff(${ECMC_AXIS_NO},${ECMC_CNTRL_KFF})"

#- Encoder
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_ACTPOS},"ax${ECMC_AXIS_NO}.enc.actpos")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCHPOS=""},"ax${ECMC_AXIS_NO}.enc.latchpos")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCH_CONTROL=""},"ax${ECMC_AXIS_NO}.enc.latchcontrol")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCH_STATUS=""},"ax${ECMC_AXIS_NO}.enc.latchstatus")"
ecmcConfigOrDie "Cfg.SetAxisHomeLatchCountOffset(${ECMC_AXIS_NO},${ECMC_HOME_LATCH_COUNT_OFFSET=0})"
ecmcConfigOrDie "Cfg.SetAxisEncScaleDenom(${ECMC_AXIS_NO},${ECMC_ENC_SCALE_DENOM})"
ecmcConfigOrDie "Cfg.SetAxisEncScaleNum(${ECMC_AXIS_NO},${ECMC_ENC_SCALE_NUM})"
ecmcConfigOrDie "Cfg.SetAxisEncType(${ECMC_AXIS_NO},${ECMC_ENC_TYPE})"
ecmcConfigOrDie "Cfg.SetAxisEncBits(${ECMC_AXIS_NO},${ECMC_ENC_BITS})"
ecmcConfigOrDie "Cfg.SetAxisEncAbsBits($(ECMC_AXIS_NO),${ECMC_ENC_ABS_BITS})"
ecmcConfigOrDie "Cfg.SetAxisEncOffset($(ECMC_AXIS_NO),${ECMC_ENC_ABS_OFFSET})"
ecmcConfigOrDie "Cfg.SetAxisEncVelFilterSize($(ECMC_AXIS_NO),${ECMC_ENC_VEL_FILTER_SIZE=100})"
ecmcConfigOrDie "Cfg.SetAxisEncPosFilterSize($(ECMC_AXIS_NO),${ECMC_ENC_POS_FILTER_SIZE=1})"
ecmcConfigOrDie "Cfg.SetAxisEncPosFilterEnable($(ECMC_AXIS_NO),${ECMC_ENC_POS_FILTER_ENABLE=0})"

#- Encoder latching
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCHPOS=""},"ax${ECMC_AXIS_NO}.enc.latchpos")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCH_CONTROL=""},"ax${ECMC_AXIS_NO}.enc.latchcontrol")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_ENC_LATCH_STATUS=""},"ax${ECMC_AXIS_NO}.enc.latchstatus")"
ecmcConfigOrDie "Cfg.SetAxisHomeLatchCountOffset(${ECMC_AXIS_NO=""},${ECMC_HOME_LATCH_COUNT_OFFSET=0})"

#- Drive
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_CONTROL},"ax${ECMC_AXIS_NO}.drv.control")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_STATUS},"ax${ECMC_AXIS_NO}.drv.status")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_VELOCITY},"ax${ECMC_AXIS_NO}.drv.velocity")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_POSITION},"ax${ECMC_AXIS_NO}.drv.position")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_BRAKE},"ax${ECMC_AXIS_NO}.drv.brake")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_DRV_REDUCE_TORQUE},"ax${ECMC_AXIS_NO}.drv.reducetorque")"
ecmcConfigOrDie "Cfg.SetAxisDrvScaleDenom(${ECMC_AXIS_NO},${ECMC_DRV_SCALE_DENOM})"
ecmcConfigOrDie "Cfg.SetAxisDrvScaleNum(${ECMC_AXIS_NO},${ECMC_DRV_SCALE_NUM})"
ecmcConfigOrDie "Cfg.SetAxisDrvBrakeOpenDelayTime(${ECMC_AXIS_NO},${ECMC_DRV_BRAKE_OPEN_DLY_TIME})"
ecmcConfigOrDie "Cfg.SetAxisDrvBrakeCloseAheadTime(${ECMC_AXIS_NO},${ECMC_DRV_BRAKE_CLOSE_AHEAD_TIME})"

#- Soft limits
ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosBwd(${ECMC_AXIS_NO},${ECMC_SOFT_LOW_LIM})"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(${ECMC_AXIS_NO},${ECMC_DXLM_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisSoftLimitPosFwd(${ECMC_AXIS_NO},${ECMC_SOFT_HIGH_LIM})"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(${ECMC_AXIS_NO},${ECMC_DXLM_ENABLE})"

#- Monitor
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_LOWLIM},"ax${ECMC_AXIS_NO}.mon.lowlim")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_HIGHLIM},"ax${ECMC_AXIS_NO}.mon.highlim")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_HOME_SWITCH},"ax${ECMC_AXIS_NO}.mon.homesensor")"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(${ECMC_EC_MON_EXT_INTERLOCK},"ax${ECMC_AXIS_NO}.mon.extinterlock")"
ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTol(${ECMC_AXIS_NO},${ECMC_MON_AT_TARGET_TOL})"
ecmcConfigOrDie "Cfg.SetAxisMonAtTargetTime(${ECMC_AXIS_NO},${ECMC_MON_AT_TARGET_TIME})"
ecmcConfigOrDie "Cfg.SetAxisMonEnableAtTargetMon(${ECMC_AXIS_NO},${ECMC_MON_AT_TARGET_ENA})"
ecmcConfigOrDie "Cfg.SetAxisMonPosLagTol(${ECMC_AXIS_NO},${ECMC_MON_LAG_MON_TOL})"
ecmcConfigOrDie "Cfg.SetAxisMonPosLagTime(${ECMC_AXIS_NO},${ECMC_MON_LAG_MON_TIME})"
ecmcConfigOrDie "Cfg.SetAxisMonEnableLagMon(${ECMC_AXIS_NO},${ECMC_MON_LAG_MON_ENA})"
ecmcConfigOrDie "Cfg.SetAxisMonMaxVel(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX})"
ecmcConfigOrDie "Cfg.SetAxisMonEnableMaxVel(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX_ENA})"
ecmcConfigOrDie "Cfg.SetAxisMonMaxVelDriveILDelay(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX_DRV_TIME})"
ecmcConfigOrDie "Cfg.SetAxisMonMaxVelTrajILDelay(${ECMC_AXIS_NO},${ECMC_MON_VELO_MAX_TRAJ_TIME})"

${ECMC_MR_MODULE="ecmcMotorRecord"}CreateAxis(${ECMC_MOTOR_PORT}, "${ECMC_AXIS_NO}", "6", ${ECMC_AXISCONFIG})

ecmcFileExist(${ECMC_MR_MODULE="ecmcMotorRecord"}.template,1,1)
dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}.template, "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO}, DESC=${ECMC_DESC}, EGU=${ECMC_EGU}, PREC=${ECMC_PREC}, VELO=${ECMC_VELO}, JVEL=${ECMC_JOG_VEL}, JAR=${ECMC_JAR}, ACCL=${ECMC_ACCL}, MRES=${ECMC_MRES}, RDBD=${ECMC_MON_AT_TARGET_TOL}, DLLM=${ECMC_SOFT_LOW_LIM}, DHLM=${ECMC_SOFT_HIGH_LIM}, HOMEPROC=${ECMC_HOME_PROC} ${ECMCAXISFIELDINIT}")

epicsEnvSet("ECMCAXISFIELDINIT",  "")

ecmcFileExist(${ECMC_MR_MODULE="ecmcMotorRecord"}home.template,1,1)
dbLoadRecords(${ECMC_MR_MODULE="ecmcMotorRecord"}home.template, "PREFIX=${ECMC_PREFIX}, MOTOR_NAME=${ECMC_MOTOR_NAME}, MOTOR_PORT=${ECMC_MOTOR_PORT}, AXIS_NO=${ECMC_AXIS_NO},HOMEPROC=${ECMC_HOME_PROC}, HOMEPOS=${ECMC_HOME_POS}, HVELTO=${ECMC_HOME_VEL_TO}, HVELFRM=${ECMC_HOME_VEL_FRM}, HOMEACC=${ECMC_HOME_ACC}, HOMEDEC=${ECMC_HOME_DEC}")

ecmcFileExist("ecmcExpression.db",1,1)
dbLoadRecords("ecmcExpression.db", "PORT=${ECMC_ASYN_PORT},A=0,Index=${ECMC_AXIS_NO},Name=${ECMC_PREFIX}${ECMC_MOTOR_NAME}")
